"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const tour_service_1 = require("../services/tour.service");
const router = (0, express_1.Router)();
router.get('/', validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const difficulty = req.query.difficulty;
        const { items, total } = await tour_service_1.tourService.list(page, limit, difficulty);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.get('/:id', async (req, res) => {
    try {
        const tour = await tour_service_1.tourService.getById(req.params.id);
        if (!tour) {
            res.status(404).json({ success: false, error: 'Tour not found' });
            return;
        }
        res.json({ success: true, data: tour });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// POST /api/tours — Admin only
router.post('/', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const tour = await tour_service_1.tourService.create(req.body);
        res.status(201).json({ success: true, data: tour, message: 'Tour created' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/tours/:id — Admin only
router.put('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await tour_service_1.tourService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Tour updated' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// DELETE /api/tours/:id — Admin only
router.delete('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await tour_service_1.tourService.delete(req.params.id);
        res.json({ success: true, message: 'Tour deleted' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=tours.js.map