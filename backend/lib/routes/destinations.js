"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const destination_service_1 = require("../services/destination.service");
const router = (0, express_1.Router)();
router.get('/', async (_req, res) => {
    try {
        const destinations = await destination_service_1.destinationService.list();
        res.json({ success: true, data: destinations });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.post('/', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const destination = await destination_service_1.destinationService.create(req.body);
        res.status(201).json({ success: true, data: destination });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.put('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await destination_service_1.destinationService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Destination updated' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.delete('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await destination_service_1.destinationService.delete(req.params.id);
        res.json({ success: true, message: 'Destination deleted' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=destinations.js.map