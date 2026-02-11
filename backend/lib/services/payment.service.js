"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.paymentService = exports.PaymentService = void 0;
const firebase_1 = require("../config/firebase");
const firestore_1 = require("firebase-admin/firestore");
class PaymentService {
    methodsCol = firebase_1.db.collection(firebase_1.Collections.PAYMENT_METHODS);
    paymentsCol = firebase_1.db.collection(firebase_1.Collections.PAYMENTS);
    async listMethods(userId) {
        const snapshot = await this.methodsCol.where('userId', '==', userId).get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    }
    async addMethod(userId, data) {
        // If setting as default, unset other defaults
        if (data.isDefault) {
            const existing = await this.methodsCol.where('userId', '==', userId).where('isDefault', '==', true).get();
            const batch = firebase_1.db.batch();
            existing.docs.forEach((doc) => batch.update(doc.ref, { isDefault: false }));
            await batch.commit();
        }
        const docRef = this.methodsCol.doc();
        const method = { ...data, userId, createdAt: firestore_1.Timestamp.now() };
        await docRef.set(method);
        return { id: docRef.id, ...method };
    }
    async removeMethod(id, userId) {
        const doc = await this.methodsCol.doc(id).get();
        if (!doc.exists || doc.data()?.userId !== userId)
            return false;
        await this.methodsCol.doc(id).delete();
        return true;
    }
    async processPayment(userId, bookingId, amount, method) {
        const docRef = this.paymentsCol.doc();
        const payment = {
            userId,
            bookingId,
            amount,
            currency: 'VND',
            method,
            status: 'completed',
            transactionId: `TXN-${Date.now()}`,
            createdAt: firestore_1.Timestamp.now(),
        };
        await docRef.set(payment);
        // Update booking payment status
        await firebase_1.db.collection(firebase_1.Collections.BOOKINGS).doc(bookingId).update({
            paymentStatus: 'paid',
            status: 'confirmed',
            updatedAt: firestore_1.Timestamp.now(),
        });
        return { id: docRef.id, ...payment };
    }
}
exports.PaymentService = PaymentService;
exports.paymentService = new PaymentService();
//# sourceMappingURL=payment.service.js.map