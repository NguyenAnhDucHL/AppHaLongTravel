import { db, Collections } from '../config/firebase';
import { Booking, BookingStatus } from '../models/types';
import { Timestamp } from 'firebase-admin/firestore';

export class BookingService {
    private col = db.collection(Collections.BOOKINGS);

    async create(data: Omit<Booking, 'id' | 'createdAt' | 'updatedAt'>): Promise<Booking> {
        const now = Timestamp.now();
        const docRef = this.col.doc();
        const booking = { ...data, createdAt: now, updatedAt: now };
        await docRef.set(booking);
        return { id: docRef.id, ...booking };
    }

    async listByUser(userId: string, status?: BookingStatus, page = 1, limit = 20): Promise<{ items: Booking[]; total: number }> {
        let query: FirebaseFirestore.Query = this.col.where('userId', '==', userId);
        if (status) query = query.where('status', '==', status);
        query = query.orderBy('createdAt', 'desc');

        const countSnap = await query.count().get();
        const total = countSnap.data().count;

        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Booking));
        return { items, total };
    }

    async getById(id: string): Promise<Booking | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Booking;
    }

    async cancel(id: string, userId: string): Promise<Booking | null> {
        const booking = await this.getById(id);
        if (!booking || booking.userId !== userId) return null;
        if (booking.status === 'cancelled' || booking.status === 'completed') return null;

        await this.col.doc(id).update({
            status: 'cancelled',
            paymentStatus: 'refunded',
            updatedAt: Timestamp.now(),
        });
        return this.getById(id);
    }

    async updateStatus(id: string, status: BookingStatus): Promise<void> {
        await this.col.doc(id).update({ status, updatedAt: Timestamp.now() });
    }

    async listAll(page = 1, limit = 20): Promise<{ items: Booking[]; total: number }> {
        const countSnap = await this.col.count().get();
        const total = countSnap.data().count;

        const offset = (page - 1) * limit;
        const snapshot = await this.col.orderBy('createdAt', 'desc').offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Booking));
        return { items, total };
    }
}

export const bookingService = new BookingService();
