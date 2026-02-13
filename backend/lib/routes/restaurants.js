"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const restaurant_service_1 = require("../services/restaurant.service");
const router = (0, express_1.Router)();
router.get('/', validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const cuisine = req.query.cuisine;
        const { items, total } = await restaurant_service_1.restaurantService.list(page, limit, cuisine);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
router.get('/:id', async (req, res) => {
    try {
        const restaurant = await restaurant_service_1.restaurantService.getById(req.params.id);
        if (!restaurant) {
            res.status(404).json({ success: false, error: 'Restaurant not found' });
            return;
        }
        res.json({ success: true, data: restaurant });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// POST /api/restaurants — Admin only
router.post('/', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const restaurant = await restaurant_service_1.restaurantService.create(req.body);
        res.status(201).json({ success: true, data: restaurant, message: 'Restaurant created' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/restaurants/:id — Admin only
router.put('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await restaurant_service_1.restaurantService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Restaurant updated' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// DELETE /api/restaurants/:id — Admin only
router.delete('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await restaurant_service_1.restaurantService.delete(req.params.id);
        res.json({ success: true, message: 'Restaurant deleted' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=restaurants.js.map