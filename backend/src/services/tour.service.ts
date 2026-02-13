import { db, Collections } from '../config/firebase';
import { Tour } from '../models/types';

export class TourService {
    private col = db.collection(Collections.TOURS);

    async list(page: number, limit: number, difficulty?: string): Promise<{ items: Tour[]; total: number }> {
        let query: FirebaseFirestore.Query = this.col;
        if (difficulty) query = query.where('difficulty', '==', difficulty);
        query = query.orderBy('rating', 'desc');

        const countSnap = await query.count().get();
        const total = countSnap.data().count;

        const offset = (page - 1) * limit;
        const snapshot = await query.offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Tour));
        return { items, total };
    }

    async getById(id: string): Promise<Tour | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Tour;
    }

    async create(data: Omit<Tour, 'id' | 'createdAt'>): Promise<Tour> {
        const docRef = await this.col.add({
            ...data,
            createdAt: new Date(),
        });
        const doc = await docRef.get();
        return { id: doc.id, ...doc.data() } as Tour;
    }

    async update(id: string, data: Partial<Tour>): Promise<void> {
        await this.col.doc(id).update({
            ...data,
            updatedAt: new Date(),
        });
    }

    async delete(id: string): Promise<void> {
        await this.col.doc(id).delete();
    }
}

export const tourService = new TourService();
