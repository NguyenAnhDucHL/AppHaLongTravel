"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dealService = exports.DealService = void 0;
const firebase_1 = require("../config/firebase");
class DealService {
    col = firebase_1.db.collection(firebase_1.Collections.DEALS);
    async list() {
        const snapshot = await this.col.orderBy('createdAt', 'desc').get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    }
    async getById(id) {
        const doc = await this.col.doc(id).get();
        if (!doc.exists)
            return null;
        return { id: doc.id, ...doc.data() };
    }
    async create(data) {
        const docRef = await this.col.add({
            ...data,
            createdAt: new Date(),
        });
        const doc = await docRef.get();
        return { id: doc.id, ...doc.data() };
    }
    async update(id, data) {
        await this.col.doc(id).update({
            ...data,
            updatedAt: new Date(),
        });
    }
    async delete(id) {
        await this.col.doc(id).delete();
    }
}
exports.DealService = DealService;
exports.dealService = new DealService();
//# sourceMappingURL=deal.service.js.map