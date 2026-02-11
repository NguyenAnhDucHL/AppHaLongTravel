"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const search_service_1 = require("../services/search.service");
const router = (0, express_1.Router)();
// GET /api/search?q=&type=
router.get('/', async (req, res) => {
    try {
        const q = req.query.q;
        if (!q || q.length < 2) {
            res.status(400).json({ success: false, error: 'Query must be at least 2 characters' });
            return;
        }
        const type = req.query.type;
        const limit = parseInt(req.query.limit) || 20;
        const { results, total } = await search_service_1.searchService.search(q, type, limit);
        res.json({ success: true, data: results, total });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/search/popular
router.get('/popular', async (_req, res) => {
    try {
        const popular = await search_service_1.searchService.getPopular();
        res.json({ success: true, data: popular });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=search.js.map