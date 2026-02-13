"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const hotel_service_1 = require("../services/hotel.service");
const router = (0, express_1.Router)();
// GET /api/hotels
router.get('/', validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const filters = {
            category: req.query.category,
            minPrice: req.query.minPrice ? parseInt(req.query.minPrice) : undefined,
            maxPrice: req.query.maxPrice ? parseInt(req.query.maxPrice) : undefined,
            featured: req.query.featured === 'true',
        };
        const { items, total } = await hotel_service_1.hotelService.list(page, limit, filters);
        res.json({
            success: true,
            data: items,
            pagination: { page, limit, total, totalPages: Math.ceil(total / limit) },
        });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to fetch hotels';
        res.status(500).json({ success: false, error: msg });
    }
});
// GET /api/hotels/featured
router.get('/featured', async (_req, res) => {
    try {
        const hotels = await hotel_service_1.hotelService.getFeatured();
        res.json({ success: true, data: hotels });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to fetch featured hotels';
        res.status(500).json({ success: false, error: msg });
    }
});
// GET /api/hotels/:id
router.get('/:id', async (req, res) => {
    try {
        const hotel = await hotel_service_1.hotelService.getById(req.params.id);
        if (!hotel) {
            res.status(404).json({ success: false, error: 'Hotel not found' });
            return;
        }
        res.json({ success: true, data: hotel });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to fetch hotel';
        res.status(500).json({ success: false, error: msg });
    }
});
// POST /api/hotels — Admin only
router.post('/', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const hotel = await hotel_service_1.hotelService.create(req.body);
        res.status(201).json({ success: true, data: hotel, message: 'Hotel created' });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to create hotel';
        res.status(500).json({ success: false, error: msg });
    }
});
// PUT /api/hotels/:id — Admin only
router.put('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await hotel_service_1.hotelService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Hotel updated' });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to update hotel';
        res.status(500).json({ success: false, error: msg });
    }
});
// DELETE /api/hotels/:id — Admin only
router.delete('/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await hotel_service_1.hotelService.delete(req.params.id);
        res.json({ success: true, message: 'Hotel deleted' });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to delete hotel';
        res.status(500).json({ success: false, error: msg });
    }
});
exports.default = router;
//# sourceMappingURL=hotels.js.map