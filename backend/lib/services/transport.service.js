"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.transportService = exports.TransportService = void 0;
const firebase_1 = require("../config/firebase");
class TransportService {
    col = firebase_1.db.collection(firebase_1.Collections.TRANSPORT);
    async listVehicles() {
        const snapshot = await this.col.where('available', '==', true).get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    }
    async getById(id) {
        const doc = await this.col.doc(id).get();
        if (!doc.exists)
            return null;
        return { id: doc.id, ...doc.data() };
    }
    async estimatePrice(vehicleType, distanceKm) {
        const snapshot = await this.col.where('vehicleType', '==', vehicleType).limit(1).get();
        if (snapshot.empty)
            return { price: 0, currency: 'VND' };
        const vehicle = snapshot.docs[0].data();
        return { price: Math.round(vehicle.pricePerKm * distanceKm), currency: 'VND' };
    }
}
exports.TransportService = TransportService;
exports.transportService = new TransportService();
//# sourceMappingURL=transport.service.js.map