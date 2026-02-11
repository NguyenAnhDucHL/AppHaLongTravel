"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.favoriteService = exports.FavoriteService = void 0;
const firebase_1 = require("../config/firebase");
const firestore_1 = require("firebase-admin/firestore");
class FavoriteService {
    col = firebase_1.db.collection(firebase_1.Collections.FAVORITES);
    async toggle(userId, itemId, itemType, itemName, itemImage) {
        const existing = await this.col
            .where('userId', '==', userId)
            .where('itemId', '==', itemId)
            .limit(1)
            .get();
        if (!existing.empty) {
            await existing.docs[0].ref.delete();
            return { isFavorite: false };
        }
        const docRef = this.col.doc();
        await docRef.set({
            userId,
            itemId,
            itemType,
            itemName,
            itemImage: itemImage || '',
            createdAt: firestore_1.Timestamp.now(),
        });
        return { isFavorite: true };
    }
    async listByUser(userId) {
        const snapshot = await this.col
            .where('userId', '==', userId)
            .orderBy('createdAt', 'desc')
            .get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    }
    async isFavorite(userId, itemId) {
        const snap = await this.col
            .where('userId', '==', userId)
            .where('itemId', '==', itemId)
            .limit(1)
            .get();
        return !snap.empty;
    }
}
exports.FavoriteService = FavoriteService;
exports.favoriteService = new FavoriteService();
//# sourceMappingURL=favorite.service.js.map