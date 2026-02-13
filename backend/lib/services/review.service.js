"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.reviewService = exports.ReviewService = void 0;
const firebase_1 = require("../config/firebase");
const firestore_1 = require("firebase-admin/firestore");
class ReviewService {
    col = firebase_1.db.collection(firebase_1.Collections.REVIEWS);
    async create(data) {
        const docRef = this.col.doc();
        const review = { ...data, createdAt: firestore_1.Timestamp.now() };
        await docRef.set(review);
        // Update item's rating & reviewCount
        const itemCol = this.getItemCollection(data.itemType);
        if (itemCol) {
            const reviewsSnap = await this.col
                .where('itemId', '==', data.itemId)
                .where('itemType', '==', data.itemType)
                .get();
            const reviews = reviewsSnap.docs.map((d) => d.data());
            const avgRating = reviews.reduce((sum, r) => sum + (r.rating || 0), 0) / reviews.length;
            await firebase_1.db.collection(itemCol).doc(data.itemId).update({
                rating: Math.round(avgRating * 10) / 10,
                reviewCount: reviews.length,
            });
        }
        return { id: docRef.id, ...review };
    }
    async listByItem(itemId, itemType, page = 1, limit = 10) {
        let query = this.col
            .where('itemId', '==', itemId)
            .where('itemType', '==', itemType)
            .orderBy('createdAt', 'desc');
        const countSnap = await this.col
            .where('itemId', '==', itemId)
            .where('itemType', '==', itemType)
            .count().get();
        const total = countSnap.data().count;
        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        return { items, total };
    }
    async listByUser(userId) {
        const snapshot = await this.col
            .where('userId', '==', userId)
            .orderBy('createdAt', 'desc')
            .get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    }
    async listAll(page = 1, limit = 20) {
        const countSnap = await this.col.count().get();
        const total = countSnap.data().count;
        const snapshot = await this.col
            .orderBy('createdAt', 'desc')
            .offset((page - 1) * limit)
            .limit(limit)
            .get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
        return { items, total };
    }
    async updateStatus(id, status) {
        await this.col.doc(id).update({ status });
    }
    async delete(id) {
        await this.col.doc(id).delete();
    }
    getItemCollection(itemType) {
        const map = {
            hotel: firebase_1.Collections.HOTELS,
            cruise: firebase_1.Collections.CRUISES,
            tour: firebase_1.Collections.TOURS,
            restaurant: firebase_1.Collections.RESTAURANTS,
        };
        return map[itemType] || null;
    }
}
exports.ReviewService = ReviewService;
exports.reviewService = new ReviewService();
//# sourceMappingURL=review.service.js.map