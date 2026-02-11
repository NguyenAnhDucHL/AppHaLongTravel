import { db, Collections } from '../config/firebase';
import { PaymentMethod, Payment } from '../models/types';
import { Timestamp } from 'firebase-admin/firestore';

export class PaymentService {
    private methodsCol = db.collection(Collections.PAYMENT_METHODS);
    private paymentsCol = db.collection(Collections.PAYMENTS);

    async listMethods(userId: string): Promise<PaymentMethod[]> {
        const snapshot = await this.methodsCol.where('userId', '==', userId).get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as PaymentMethod));
    }

    async addMethod(userId: string, data: Omit<PaymentMethod, 'id' | 'userId' | 'createdAt'>): Promise<PaymentMethod> {
        // If setting as default, unset other defaults
        if (data.isDefault) {
            const existing = await this.methodsCol.where('userId', '==', userId).where('isDefault', '==', true).get();
            const batch = db.batch();
            existing.docs.forEach((doc) => batch.update(doc.ref, { isDefault: false }));
            await batch.commit();
        }

        const docRef = this.methodsCol.doc();
        const method = { ...data, userId, createdAt: Timestamp.now() };
        await docRef.set(method);
        return { id: docRef.id, ...method };
    }

    async removeMethod(id: string, userId: string): Promise<boolean> {
        const doc = await this.methodsCol.doc(id).get();
        if (!doc.exists || doc.data()?.userId !== userId) return false;
        await this.methodsCol.doc(id).delete();
        return true;
    }

    async processPayment(userId: string, bookingId: string, amount: number, method: string): Promise<Payment> {
        const docRef = this.paymentsCol.doc();
        const payment: Omit<Payment, 'id'> = {
            userId,
            bookingId,
            amount,
            currency: 'VND',
            method,
            status: 'completed',
            transactionId: `TXN-${Date.now()}`,
            createdAt: Timestamp.now(),
        };
        await docRef.set(payment);

        // Update booking payment status
        await db.collection(Collections.BOOKINGS).doc(bookingId).update({
            paymentStatus: 'paid',
            status: 'confirmed',
            updatedAt: Timestamp.now(),
        });

        return { id: docRef.id, ...payment };
    }
}

export const paymentService = new PaymentService();
