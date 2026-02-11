"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const validation_1 = require("../middleware/validation");
const cruise_service_1 = require("../services/cruise.service");
const router = (0, express_1.Router)();
router.get('/', validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const { items, total } = await cruise_service_1.cruiseService.list(page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.get('/:id', async (req, res) => {
    try {
        const cruise = await cruise_service_1.cruiseService.getById(req.params.id);
        if (!cruise) {
            res.status(404).json({ success: false, error: 'Cruise not found' });
            return;
        }
        res.json({ success: true, data: cruise });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=cruises.js.map