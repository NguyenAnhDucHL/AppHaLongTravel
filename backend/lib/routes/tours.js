"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
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
exports.default = router;
//# sourceMappingURL=tours.js.map