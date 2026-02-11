"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authService = exports.AuthService = void 0;
const firebase_1 = require("../config/firebase");
const types_1 = require("../models/types");
const firestore_1 = require("firebase-admin/firestore");
class AuthService {
    /**
     * Register a new user with default 'customer' role
     */
    async register(uid, email, displayName, phone) {
        const now = firestore_1.Timestamp.now();
        const user = {
            email,
            displayName,
            phone: phone || '',
            avatar: '',
            bio: '',
            role: 'customer',
            permissions: types_1.ROLE_PERMISSIONS.customer,
            assignedServices: [],
            isActive: true,
            language: 'vi_VN',
            currency: 'VND',
            darkMode: false,
            createdAt: now,
            updatedAt: now,
        };
        await firebase_1.db.collection(firebase_1.Collections.USERS).doc(uid).set(user);
        return { id: uid, ...user };
    }
    /**
     * Get user profile
     */
    async getProfile(uid) {
        const doc = await firebase_1.db.collection(firebase_1.Collections.USERS).doc(uid).get();
        if (!doc.exists)
            return null;
        return { id: doc.id, ...doc.data() };
    }
    /**
     * Update user profile (non-sensitive fields only)
     */
    async updateProfile(uid, data) {
        const updateData = {
            ...data,
            updatedAt: firestore_1.Timestamp.now(),
        };
        // Don't allow updating sensitive fields via profile update
        delete updateData.id;
        delete updateData.role;
        delete updateData.permissions;
        delete updateData.assignedServices;
        delete updateData.isActive;
        delete updateData.createdAt;
        await firebase_1.db.collection(firebase_1.Collections.USERS).doc(uid).update(updateData);
        const updated = await this.getProfile(uid);
        return updated;
    }
    /**
     * Delete user account
     */
    async deleteAccount(uid) {
        await firebase_1.db.collection(firebase_1.Collections.USERS).doc(uid).delete();
        await firebase_1.auth.deleteUser(uid);
    }
    // ===== ADMIN USER MANAGEMENT =====
    /**
     * Set user role (admin only)
     */
    async setUserRole(targetUid, role, assignedServices) {
        const updateData = {
            role,
            permissions: types_1.ROLE_PERMISSIONS[role],
            updatedAt: firestore_1.Timestamp.now(),
        };
        if (role === 'collaborator' && assignedServices) {
            updateData.assignedServices = assignedServices;
        }
        else if (role !== 'collaborator') {
            updateData.assignedServices = [];
        }
        await firebase_1.db.collection(firebase_1.Collections.USERS).doc(targetUid).update(updateData);
        const updated = await this.getProfile(targetUid);
        return updated;
    }
    /**
     * Toggle user active status (ban/unban)
     */
    async setUserActive(targetUid, isActive) {
        await firebase_1.db.collection(firebase_1.Collections.USERS).doc(targetUid).update({
            isActive,
            updatedAt: firestore_1.Timestamp.now(),
        });
        const updated = await this.getProfile(targetUid);
        return updated;
    }
    /**
     * List all users with optional role filter
     */
    async listUsers(role, page = 1, limit = 20) {
        let query = firebase_1.db.collection(firebase_1.Collections.USERS).orderBy('createdAt', 'desc');
        if (role) {
            query = query.where('role', '==', role);
        }
        // Get total count
        const countSnapshot = await query.count().get();
        const total = countSnapshot.data().count;
        // Paginate
        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();
        const users = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        return { users, total };
    }
    /**
     * Assign services to a collaborator
     */
    async assignServices(collaboratorUid, serviceIds) {
        const user = await this.getProfile(collaboratorUid);
        if (!user || user.role !== 'collaborator') {
            throw new Error('User is not a collaborator');
        }
        await firebase_1.db.collection(firebase_1.Collections.USERS).doc(collaboratorUid).update({
            assignedServices: serviceIds,
            updatedAt: firestore_1.Timestamp.now(),
        });
        const updated = await this.getProfile(collaboratorUid);
        return updated;
    }
    /**
     * Get dashboard user stats
     */
    async getUserStats() {
        const roles = ['admin', 'collaborator', 'customer', 'guest'];
        const stats = {};
        for (const role of roles) {
            const snapshot = await firebase_1.db.collection(firebase_1.Collections.USERS)
                .where('role', '==', role)
                .count()
                .get();
            stats[role] = snapshot.data().count;
        }
        const totalSnapshot = await firebase_1.db.collection(firebase_1.Collections.USERS).count().get();
        stats.total = totalSnapshot.data().count;
        return stats;
    }
}
exports.AuthService = AuthService;
exports.authService = new AuthService();
//# sourceMappingURL=auth.service.js.map