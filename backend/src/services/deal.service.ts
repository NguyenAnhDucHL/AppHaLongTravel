import { db, Collections } from '../config/firebase';
import { Deal } from '../models/types';

export class DealService {
    private col = db.collection(Collections.DEALS);

    async list(): Promise<Deal[]> {
        const snapshot = await this.col.orderBy('createdAt', 'desc').get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Deal));
    }

    async getById(id: string): Promise<Deal | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Deal;
    }

    async create(data: Omit<Deal, 'id' | 'createdAt'>): Promise<Deal> {
        const docRef = await this.col.add({
            ...data,
            createdAt: new Date(),
        });
        const doc = await docRef.get();
        return { id: doc.id, ...doc.data() } as Deal;
    }

    async update(id: string, data: Partial<Deal>): Promise<void> {
        await this.col.doc(id).update({
            ...data,
            updatedAt: new Date(),
        });
    }

    async delete(id: string): Promise<void> {
        await this.col.doc(id).delete();
    }
}

export const dealService = new DealService();
