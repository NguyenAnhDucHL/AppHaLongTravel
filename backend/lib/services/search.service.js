"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.searchService = exports.SearchService = void 0;
const firebase_1 = require("../config/firebase");
class SearchService {
    async search(query, type, limit = 20) {
        const q = query.toLowerCase();
        const results = [];
        const collections = type
            ? [type]
            : [firebase_1.Collections.HOTELS, firebase_1.Collections.CRUISES, firebase_1.Collections.TOURS, firebase_1.Collections.RESTAURANTS];
        for (const col of collections) {
            const snapshot = await firebase_1.db.collection(col).get();
            for (const doc of snapshot.docs) {
                const data = doc.data();
                const name = (data.name || '').toLowerCase();
                const desc = (data.description || '').toLowerCase();
                const addr = (data.address || data.location || '').toLowerCase();
                if (name.includes(q) || desc.includes(q) || addr.includes(q)) {
                    results.push({ id: doc.id, type: col, ...data });
                }
            }
            if (results.length >= limit)
                break;
        }
        return { results: results.slice(0, limit), total: results.length };
    }
    async getPopular() {
        return [
            'Ha Long Bay', 'Bai Tu Long', 'Yen Tu', 'Co To Island',
            'Tuan Chau', 'Bai Chay', 'Mong Cai', 'Quan Lan',
        ];
    }
}
exports.SearchService = SearchService;
exports.searchService = new SearchService();
//# sourceMappingURL=search.service.js.map