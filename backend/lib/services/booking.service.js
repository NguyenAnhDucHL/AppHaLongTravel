"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.bookingService = exports.BookingService = void 0;
const firebase_1 = require("../config/firebase");
const firestore_1 = require("firebase-admin/firestore");
class BookingService {
    col = firebase_1.db.collection(firebase_1.Collections.BOOKINGS);
    async create(data) {
        const now = firestore_1.Timestamp.now();
        const docRef = this.col.doc();
        const booking = { ...data, createdAt: now, updatedAt: now };
        await docRef.set(booking);
        return { id: docRef.id, ...booking };
    }
    async listByUser(userId, status, page = 1, limit = 20) {
        let query = this.col.where('userId', '==', userId);
        if (status)
            query = query.where('status', '==', status);
        query = query.orderBy('createdAt', 'desc');
        const countSnap = await query.count().get();
        const total = countSnap.data().count;
        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        return { items, total };
    }
    async getById(id) {
        const doc = await this.col.doc(id).get();
        if (!doc.exists)
            return null;
        return { id: doc.id, ...doc.data() };
    }
    async cancel(id, userId) {
        const booking = await this.getById(id);
        if (!booking || booking.userId !== userId)
            return null;
        if (booking.status === 'cancelled' || booking.status === 'completed')
            return null;
        await this.col.doc(id).update({
            status: 'cancelled',
            paymentStatus: 'refunded',
            updatedAt: firestore_1.Timestamp.now(),
        });
        return this.getById(id);
    }
    async updateStatus(id, status) {
        await this.col.doc(id).update({ status, updatedAt: firestore_1.Timestamp.now() });
    }
    async listAll(page = 1, limit = 20) {
        const countSnap = await this.col.count().get();
        const total = countSnap.data().count;
        const offset = (page - 1) * limit;
        const snapshot = await this.col.orderBy('createdAt', 'desc').offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        return { items, total };
    }
}
exports.BookingService = BookingService;
exports.bookingService = new BookingService();
//# sourceMappingURL=booking.service.js.map