"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.destinationService = exports.DestinationService = void 0;
const firebase_1 = require("../config/firebase");
class DestinationService {
    col = firebase_1.db.collection(firebase_1.Collections.DESTINATIONS);
    async list() {
        const snapshot = await this.col.orderBy('views', 'desc').get();
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
exports.DestinationService = DestinationService;
exports.destinationService = new DestinationService();
//# sourceMappingURL=destination.service.js.map