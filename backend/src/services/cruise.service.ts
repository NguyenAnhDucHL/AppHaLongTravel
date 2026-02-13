import { db, Collections } from '../config/firebase';
import { Cruise } from '../models/types';

export class CruiseService {
    private col = db.collection(Collections.CRUISES);

    async list(page: number, limit: number): Promise<{ items: Cruise[]; total: number }> {
        const countSnap = await this.col.count().get();
        const total = countSnap.data().count;

        const offset = (page - 1) * limit;
        const snapshot = await this.col.orderBy('rating', 'desc').offset(offset).limit(limit).get();
        const items = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Cruise));
        return { items, total };
    }

    async getById(id: string): Promise<Cruise | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Cruise;
    }

    async create(data: Omit<Cruise, 'id' | 'createdAt'>): Promise<Cruise> {
        const docRef = await this.col.add({
            ...data,
            createdAt: new Date(),
        });
        const doc = await docRef.get();
        return { id: doc.id, ...doc.data() } as Cruise;
    }

    async update(id: string, data: Partial<Cruise>): Promise<void> {
        await this.col.doc(id).update({
            ...data,
            updatedAt: new Date(),
        });
    }

    async delete(id: string): Promise<void> {
        await this.col.doc(id).delete();
    }
}

export const cruiseService = new CruiseService();
