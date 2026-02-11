import { db, Collections } from '../config/firebase';
import { Hotel } from '../models/types';

export class HotelService {
    private col = db.collection(Collections.HOTELS);

    async list(page: number, limit: number, filters?: { category?: string; minPrice?: number; maxPrice?: number; featured?: boolean }): Promise<{ items: Hotel[]; total: number }> {
        let query: FirebaseFirestore.Query = this.col;

        if (filters?.category) query = query.where('category', '==', filters.category);
        if (filters?.featured) query = query.where('featured', '==', true);
        if (filters?.minPrice) query = query.where('pricePerNight', '>=', filters.minPrice);
        if (filters?.maxPrice) query = query.where('pricePerNight', '<=', filters.maxPrice);

        query = query.orderBy('rating', 'desc');

        const countSnap = await query.count().get();
        const total = countSnap.data().count;

        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Hotel));

        return { items, total };
    }

    async getById(id: string): Promise<Hotel | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Hotel;
    }

    async getFeatured(limit = 5): Promise<Hotel[]> {
        const snapshot = await this.col
            .where('featured', '==', true)
            .orderBy('rating', 'desc')
            .limit(limit)
            .get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Hotel));
    }
}

export const hotelService = new HotelService();
