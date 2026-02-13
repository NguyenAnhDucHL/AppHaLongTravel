"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.restaurantService = exports.RestaurantService = void 0;
const firebase_1 = require("../config/firebase");
class RestaurantService {
    col = firebase_1.db.collection(firebase_1.Collections.RESTAURANTS);
    async list(page, limit, cuisine) {
        let query = this.col;
        if (cuisine)
            query = query.where('cuisine', 'array-contains', cuisine);
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
exports.RestaurantService = RestaurantService;
exports.restaurantService = new RestaurantService();
//# sourceMappingURL=restaurant.service.js.map