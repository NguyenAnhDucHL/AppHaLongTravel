"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.hotelService = exports.HotelService = void 0;
const firebase_1 = require("../config/firebase");
class HotelService {
    col = firebase_1.db.collection(firebase_1.Collections.HOTELS);
    async list(page, limit, filters) {
        let query = this.col;
        if (filters?.category)
            query = query.where('category', '==', filters.category);
        if (filters?.featured)
            query = query.where('featured', '==', true);
        if (filters?.minPrice)
            query = query.where('pricePerNight', '>=', filters.minPrice);
        if (filters?.maxPrice)
            query = query.where('pricePerNight', '<=', filters.maxPrice);
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
    async getFeatured(limit = 5) {
        const snapshot = await this.col
            .where('featured', '==', true)
            .orderBy('rating', 'desc')
            .limit(limit)
            .get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    }
}
exports.HotelService = HotelService;
exports.hotelService = new HotelService();
//# sourceMappingURL=hotel.service.js.map