"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
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
// POST /api/transport — Admin only
router.post('/', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const transport = await transport_service_1.transportService.create(req.body);
        res.status(201).json({ success: true, data: transport, message: 'Transport created' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/transport/:id — Admin only
router.put('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await transport_service_1.transportService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Transport updated' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// DELETE /api/transport/:id — Admin only
router.delete('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await transport_service_1.transportService.delete(req.params.id);
        res.json({ success: true, message: 'Transport deleted' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=transport.js.map