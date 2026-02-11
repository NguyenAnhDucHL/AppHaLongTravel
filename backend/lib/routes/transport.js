"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const transport_service_1 = require("../services/transport.service");
const router = (0, express_1.Router)();
router.get('/vehicles', async (_req, res) => {
    try {
        const vehicles = await transport_service_1.transportService.listVehicles();
        res.json({ success: true, data: vehicles });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.get('/estimate', async (req, res) => {
    try {
        const vehicleType = req.query.vehicleType;
        const distanceKm = parseFloat(req.query.distanceKm);
        if (!vehicleType || isNaN(distanceKm)) {
            res.status(400).json({ success: false, error: 'vehicleType and distanceKm required' });
            return;
        }
        const estimate = await transport_service_1.transportService.estimatePrice(vehicleType, distanceKm);
        res.json({ success: true, data: estimate });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=transport.js.map