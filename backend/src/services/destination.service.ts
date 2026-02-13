import { db, Collections } from '../config/firebase';
import { Destination } from '../models/types';

export class DestinationService {
    private col = db.collection(Collections.DESTINATIONS);

    async list(): Promise<Destination[]> {
        const snapshot = await this.col.orderBy('views', 'desc').get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Destination));
    }

    async getById(id: string): Promise<Destination | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Destination;
    }

    async create(data: Omit<Destination, 'id' | 'createdAt'>): Promise<Destination> {
        const docRef = await this.col.add({
            ...data,
            createdAt: new Date(),
        });
        const doc = await docRef.get();
        return { id: doc.id, ...doc.data() } as Destination;
    }

    async update(id: string, data: Partial<Destination>): Promise<void> {
        await this.col.doc(id).update({
            ...data,
            updatedAt: new Date(),
        });
    }

    async delete(id: string): Promise<void> {
        await this.col.doc(id).delete();
    }
}

export const destinationService = new DestinationService();
