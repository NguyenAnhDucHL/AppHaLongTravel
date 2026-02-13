import { db, Collections } from '../config/firebase';
import { Restaurant } from '../models/types';

export class RestaurantService {
    private col = db.collection(Collections.RESTAURANTS);

    async list(page: number, limit: number, cuisine?: string): Promise<{ items: Restaurant[]; total: number }> {
        let query: FirebaseFirestore.Query = this.col;
        if (cuisine) query = query.where('cuisine', 'array-contains', cuisine);
        query = query.orderBy('rating', 'desc');

        const countSnap = await query.count().get();
        const total = countSnap.data().count;

        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Restaurant));
        return { items, total };
    }

    async getById(id: string): Promise<Restaurant | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Restaurant;
    }

    async create(data: Omit<Restaurant, 'id' | 'createdAt'>): Promise<Restaurant> {
        const docRef = await this.col.add({
            ...data,
            createdAt: new Date(),
        });
        const doc = await docRef.get();
        return { id: doc.id, ...doc.data() } as Restaurant;
    }

    async update(id: string, data: Partial<Restaurant>): Promise<void> {
        await this.col.doc(id).update({
            ...data,
            updatedAt: new Date(),
        });
    }

    async delete(id: string): Promise<void> {
        await this.col.doc(id).delete();
    }
}

export const restaurantService = new RestaurantService();
