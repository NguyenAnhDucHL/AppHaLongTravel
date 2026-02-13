"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.cruiseService = exports.CruiseService = void 0;
const firebase_1 = require("../config/firebase");
class CruiseService {
    col = firebase_1.db.collection(firebase_1.Collections.CRUISES);
    async list(page, limit) {
        const countSnap = await this.col.count().get();
        const total = countSnap.data().count;
        const offset = (page - 1) * limit;
        const snapshot = await this.col.orderBy('rating', 'desc').offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        return { items, total };
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
exports.CruiseService = CruiseService;
exports.cruiseService = new CruiseService();
//# sourceMappingURL=cruise.service.js.map