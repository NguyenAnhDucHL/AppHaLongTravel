import { db, Collections } from '../config/firebase';
import { Notification } from '../models/types';
import { Timestamp } from 'firebase-admin/firestore';

export class NotificationService {
    private col = db.collection(Collections.NOTIFICATIONS);

    async listByUser(userId: string, page = 1, limit = 20): Promise<{ items: Notification[]; total: number; unread: number }> {
        const baseQuery = this.col.where('userId', '==', userId);

        const countSnap = await baseQuery.count().get();
        const total = countSnap.data().count;

        const unreadSnap = await baseQuery.where('read', '==', false).count().get();
        const unread = unreadSnap.data().count;

        const offset = (page - 1) * limit;
        const snapshot = await baseQuery.orderBy('createdAt', 'desc').offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Notification));

        return { items, total, unread };
    }

    async markAsRead(id: string): Promise<void> {
        await this.col.doc(id).update({ read: true });
    }

    async markAllRead(userId: string): Promise<number> {
        const snapshot = await this.col
            .where('userId', '==', userId)
            .where('read', '==', false)
            .get();

        const batch = db.batch();
        snapshot.docs.forEach((doc) => batch.update(doc.ref, { read: true }));
        await batch.commit();
        return snapshot.size;
    }

    async create(userId: string, title: string, body: string, type: Notification['type'], data?: Record<string, string>): Promise<Notification> {
        const docRef = this.col.doc();
        const notification = {
            userId,
            title,
            body,
            type,
            read: false,
            data: data || {},
            createdAt: Timestamp.now(),
        };
        await docRef.set(notification);
        return { id: docRef.id, ...notification };
    }
}

export const notificationService = new NotificationService();
