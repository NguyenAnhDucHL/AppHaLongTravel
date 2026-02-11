import { db, Collections } from '../config/firebase';
import { Favorite } from '../models/types';
import { Timestamp } from 'firebase-admin/firestore';

export class FavoriteService {
    private col = db.collection(Collections.FAVORITES);

    async toggle(userId: string, itemId: string, itemType: string, itemName: string, itemImage?: string): Promise<{ isFavorite: boolean }> {
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
            createdAt: Timestamp.now(),
        });
        return { isFavorite: true };
    }

    async listByUser(userId: string): Promise<Favorite[]> {
        const snapshot = await this.col
            .where('userId', '==', userId)
            .orderBy('createdAt', 'desc')
            .get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Favorite));
    }

    async isFavorite(userId: string, itemId: string): Promise<boolean> {
        const snap = await this.col
            .where('userId', '==', userId)
            .where('itemId', '==', itemId)
            .limit(1)
            .get();
        return !snap.empty;
    }
}

export const favoriteService = new FavoriteService();
