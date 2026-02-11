import { db, Collections } from '../config/firebase';

export class SearchService {
    async search(query: string, type?: string, limit = 20): Promise<{ results: Record<string, unknown>[]; total: number }> {
        const q = query.toLowerCase();
        const results: Record<string, unknown>[] = [];

        const collections = type
            ? [type]
            : [Collections.HOTELS, Collections.CRUISES, Collections.TOURS, Collections.RESTAURANTS];

        for (const col of collections) {
            const snapshot = await db.collection(col).get();
            for (const doc of snapshot.docs) {
                const data = doc.data();
                const name = (data.name || '').toLowerCase();
                const desc = (data.description || '').toLowerCase();
                const addr = (data.address || data.location || '').toLowerCase();

                if (name.includes(q) || desc.includes(q) || addr.includes(q)) {
                    results.push({ id: doc.id, type: col, ...data });
                }
            }
            if (results.length >= limit) break;
        }

        return { results: results.slice(0, limit), total: results.length };
    }

    async getPopular(): Promise<string[]> {
        return [
            'Ha Long Bay', 'Bai Tu Long', 'Yen Tu', 'Co To Island',
            'Tuan Chau', 'Bai Chay', 'Mong Cai', 'Quan Lan',
        ];
    }
}

export const searchService = new SearchService();
