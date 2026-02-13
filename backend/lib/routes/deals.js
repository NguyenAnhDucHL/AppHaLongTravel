"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const deal_service_1 = require("../services/deal.service");
const router = (0, express_1.Router)();
router.get('/', async (_req, res) => {
    try {
        const deals = await deal_service_1.dealService.list();
        res.json({ success: true, data: deals });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.post('/', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const deal = await deal_service_1.dealService.create(req.body);
        res.status(201).json({ success: true, data: deal });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.put('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await deal_service_1.dealService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Deal updated' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.delete('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await deal_service_1.dealService.delete(req.params.id);
        res.json({ success: true, message: 'Deal deleted' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=deals.js.map