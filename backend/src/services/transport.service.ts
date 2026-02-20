import { db, Collections } from '../config/firebase';
import { Transport } from '../models/types';

export class TransportService {
    private col = db.collection(Collections.TRANSPORT);

    async listVehicles(): Promise<Transport[]> {
        const snapshot = await this.col.where('available', '==', true).get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Transport));
    }

    async listAll(): Promise<Transport[]> {
        const snapshot = await this.col.get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as Transport));
    }

    async getById(id: string): Promise<Transport | null> {
        const doc = await this.col.doc(id).get();
        if (!doc.exists) return null;
        return { id: doc.id, ...doc.data() } as Transport;
    }

    async estimatePrice(vehicleType: string, distanceKm: number): Promise<{ price: number; currency: string }> {
        const snapshot = await this.col.where('vehicleType', '==', vehicleType).limit(1).get();
        if (snapshot.empty) return { price: 0, currency: 'VND' };
        const vehicle = snapshot.docs[0].data() as Transport;
        return { price: Math.round(vehicle.pricePerKm * distanceKm), currency: 'VND' };
    }

    async create(data: Omit<Transport, 'id'>): Promise<Transport> {
        const docRef = await this.col.add({
            ...data,
            createdAt: new Date(),
        });
        const doc = await docRef.get();
        return { id: doc.id, ...doc.data() } as Transport;
    }

    async update(id: string, data: Partial<Transport>): Promise<void> {
        await this.col.doc(id).update({
            ...data,
            updatedAt: new Date(),
        });
    }

    async delete(id: string): Promise<void> {
        await this.col.doc(id).delete();
    }
}

export const transportService = new TransportService();
