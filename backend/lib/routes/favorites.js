"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const favorite_service_1 = require("../services/favorite.service");
const router = (0, express_1.Router)();
// GET /api/favorites
router.get('/', auth_1.authenticate, async (req, res) => {
    try {
        const favorites = await favorite_service_1.favoriteService.listByUser(req.uid);
        res.json({ success: true, data: favorites });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// POST /api/favorites/toggle
router.post('/toggle', auth_1.authenticate, async (req, res) => {
    try {
        const { itemId, itemType, itemName, itemImage } = req.body;
        if (!itemId || !itemType) {
            res.status(400).json({ success: false, error: 'itemId and itemType required' });
            return;
        }
        const result = await favorite_service_1.favoriteService.toggle(req.uid, itemId, itemType, itemName || '', itemImage);
        res.json({ success: true, data: result });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/favorites/check/:itemId
router.get('/check/:itemId', auth_1.authenticate, async (req, res) => {
    try {
        const isFav = await favorite_service_1.favoriteService.isFavorite(req.uid, req.params.itemId);
        res.json({ success: true, data: { isFavorite: isFav } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=favorites.js.map