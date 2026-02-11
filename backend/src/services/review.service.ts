import { db, Collections } from '../config/firebase';
import { Review } from '../models/types';
import { Timestamp } from 'firebase-admin/firestore';

export class ReviewService {
    private col = db.collection(Collections.REVIEWS);

    async create(data: Omit<Review, 'id' | 'createdAt'>): Promise<Review> {
        const docRef = this.col.doc();
        const review = { ...data, createdAt: Timestamp.now() };
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
            await db.collection(itemCol).doc(data.itemId).update({
                rating: Math.round(avgRating * 10) / 10,
                reviewCount: reviews.length,
            });
        }

        return { id: docRef.id, ...review };
    }

    async listByItem(itemId: string, itemType: string, page = 1, limit = 10): Promise<{ items: Review[]; total: number }> {
        let query: FirebaseFirestore.Query = this.col
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
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Review));
        return { items, total };
    }

    async listByUser(userId: string): Promise<Review[]> {
        const snapshot = await this.col
            .where('userId', '==', userId)
            .orderBy('createdAt', 'desc')
            .get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Review));
    }

    private getItemCollection(itemType: string): string | null {
        const map: Record<string, string> = {
            hotel: Collections.HOTELS,
            cruise: Collections.CRUISES,
            tour: Collections.TOURS,
            restaurant: Collections.RESTAURANTS,
        };
        return map[itemType] || null;
    }
}

export const reviewService = new ReviewService();
