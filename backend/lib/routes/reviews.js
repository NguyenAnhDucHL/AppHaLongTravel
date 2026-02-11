"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const review_service_1 = require("../services/review.service");
const router = (0, express_1.Router)();
// POST /api/reviews
router.post('/', auth_1.authenticate, (0, validation_1.validateBody)(['itemId', 'itemType', 'rating', 'text']), async (req, res) => {
    try {
        const review = await review_service_1.reviewService.create({
            ...req.body,
            userId: req.uid,
            userName: req.body.userName || 'Anonymous',
            photos: req.body.photos || [],
            aspectRatings: req.body.aspectRatings || { cleanliness: 0, service: 0, location: 0, value: 0 },
        });
        res.status(201).json({ success: true, data: review });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/reviews/my
router.get('/my', auth_1.authenticate, async (req, res) => {
    try {
        const reviews = await review_service_1.reviewService.listByUser(req.uid);
        res.json({ success: true, data: reviews });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/reviews/item/:itemType/:itemId
router.get('/item/:itemType/:itemId', validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const { items, total } = await review_service_1.reviewService.listByItem(req.params.itemId, req.params.itemType, page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=reviews.js.map