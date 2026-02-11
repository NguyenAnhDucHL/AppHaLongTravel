import { db, auth as fbAuth, Collections } from '../config/firebase';
import { User, UserRole, ROLE_PERMISSIONS } from '../models/types';
import { Timestamp } from 'firebase-admin/firestore';

export class AuthService {
    /**
     * Register a new user with default 'customer' role
     */
    async register(uid: string, email: string, displayName: string, phone?: string): Promise<User> {
        const now = Timestamp.now();
        const user: Omit<User, 'id'> = {
            email,
            displayName,
            phone: phone || '',
            avatar: '',
            bio: '',
            role: 'customer',
            permissions: ROLE_PERMISSIONS.customer,
            assignedServices: [],
            isActive: true,
            language: 'vi_VN',
            currency: 'VND',
            darkMode: false,
            createdAt: now,
            updatedAt: now,
        };

        await db.collection(Collections.USERS).doc(uid).set(user);
        return { id: uid, ...user };
    }

    /**
     * Get user profile
     */
    async getProfile(uid: string): Promise<User | null> {
        const doc = await db.collection(Collections.USERS).doc(uid).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as User;
    }

    /**
     * Update user profile (non-sensitive fields only)
     */
    async updateProfile(uid: string, data: Partial<User>): Promise<User> {
        const updateData = {
            ...data,
            updatedAt: Timestamp.now(),
        };
        // Don't allow updating sensitive fields via profile update
        delete (updateData as Record<string, unknown>).id;
        delete (updateData as Record<string, unknown>).role;
        delete (updateData as Record<string, unknown>).permissions;
        delete (updateData as Record<string, unknown>).assignedServices;
        delete (updateData as Record<string, unknown>).isActive;
        delete (updateData as Record<string, unknown>).createdAt;

        await db.collection(Collections.USERS).doc(uid).update(updateData);
        const updated = await this.getProfile(uid);
        return updated!;
    }

    /**
     * Delete user account
     */
    async deleteAccount(uid: string): Promise<void> {
        await db.collection(Collections.USERS).doc(uid).delete();
        await fbAuth.deleteUser(uid);
    }

    // ===== ADMIN USER MANAGEMENT =====

    /**
     * Set user role (admin only)
     */
    async setUserRole(targetUid: string, role: UserRole, assignedServices?: string[]): Promise<User> {
        const updateData: Record<string, unknown> = {
            role,
            permissions: ROLE_PERMISSIONS[role],
            updatedAt: Timestamp.now(),
        };

        if (role === 'collaborator' && assignedServices) {
            updateData.assignedServices = assignedServices;
        } else if (role !== 'collaborator') {
            updateData.assignedServices = [];
        }

        await db.collection(Collections.USERS).doc(targetUid).update(updateData);
        const updated = await this.getProfile(targetUid);
        return updated!;
    }

    /**
     * Toggle user active status (ban/unban)
     */
    async setUserActive(targetUid: string, isActive: boolean): Promise<User> {
        await db.collection(Collections.USERS).doc(targetUid).update({
            isActive,
            updatedAt: Timestamp.now(),
        });
        const updated = await this.getProfile(targetUid);
        return updated!;
    }

    /**
     * List all users with optional role filter
     */
    async listUsers(role?: UserRole, page: number = 1, limit: number = 20): Promise<{ users: User[]; total: number }> {
        let query = db.collection(Collections.USERS).orderBy('createdAt', 'desc');

        if (role) {
            query = query.where('role', '==', role) as FirebaseFirestore.Query;
        }

        // Get total count
        const countSnapshot = await query.count().get();
        const total = countSnapshot.data().count;

        // Paginate
        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();

        const users = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as User));
        return { users, total };
    }

    /**
     * Assign services to a collaborator
     */
    async assignServices(collaboratorUid: string, serviceIds: string[]): Promise<User> {
        const user = await this.getProfile(collaboratorUid);
        if (!user || user.role !== 'collaborator') {
            throw new Error('User is not a collaborator');
        }

        await db.collection(Collections.USERS).doc(collaboratorUid).update({
            assignedServices: serviceIds,
            updatedAt: Timestamp.now(),
        });

        const updated = await this.getProfile(collaboratorUid);
        return updated!;
    }

    /**
     * Get dashboard user stats
     */
    async getUserStats(): Promise<Record<string, number>> {
        const roles: UserRole[] = ['admin', 'collaborator', 'customer', 'guest'];
        const stats: Record<string, number> = {};

        for (const role of roles) {
            const snapshot = await db.collection(Collections.USERS)
                .where('role', '==', role)
                .count()
                .get();
            stats[role] = snapshot.data().count;
        }

        const totalSnapshot = await db.collection(Collections.USERS).count().get();
        stats.total = totalSnapshot.data().count;

        return stats;
    }
}

export const authService = new AuthService();
