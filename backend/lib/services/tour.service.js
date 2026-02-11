"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.tourService = exports.TourService = void 0;
const firebase_1 = require("../config/firebase");
class TourService {
    col = firebase_1.db.collection(firebase_1.Collections.TOURS);
    async list(page, limit, difficulty) {
        let query = this.col;
        if (difficulty)
            query = query.where('difficulty', '==', difficulty);
        query = query.orderBy('rating', 'desc');
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
}
exports.TourService = TourService;
exports.tourService = new TourService();
//# sourceMappingURL=tour.service.js.map