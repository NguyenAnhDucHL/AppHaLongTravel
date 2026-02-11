"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notificationService = exports.NotificationService = void 0;
const firebase_1 = require("../config/firebase");
const firestore_1 = require("firebase-admin/firestore");
class NotificationService {
    col = firebase_1.db.collection(firebase_1.Collections.NOTIFICATIONS);
    async listByUser(userId, page = 1, limit = 20) {
        const baseQuery = this.col.where('userId', '==', userId);
        const countSnap = await baseQuery.count().get();
        const total = countSnap.data().count;
        const unreadSnap = await baseQuery.where('read', '==', false).count().get();
        const unread = unreadSnap.data().count;
        const offset = (page - 1) * limit;
        const snapshot = await baseQuery.orderBy('createdAt', 'desc').offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        return { items, total, unread };
    }
    async markAsRead(id) {
        await this.col.doc(id).update({ read: true });
    }
    async markAllRead(userId) {
        const snapshot = await this.col
            .where('userId', '==', userId)
            .where('read', '==', false)
            .get();
        const batch = firebase_1.db.batch();
        snapshot.docs.forEach((doc) => batch.update(doc.ref, { read: true }));
        await batch.commit();
        return snapshot.size;
    }
    async create(userId, title, body, type, data) {
        const docRef = this.col.doc();
        const notification = {
            userId,
            title,
            body,
            type,
            read: false,
            data: data || {},
            createdAt: firestore_1.Timestamp.now(),
        };
        await docRef.set(notification);
        return { id: docRef.id, ...notification };
    }
}
exports.NotificationService = NotificationService;
exports.notificationService = new NotificationService();
//# sourceMappingURL=notification.service.js.map