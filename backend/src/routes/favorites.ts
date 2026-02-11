import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import { favoriteService } from '../services/favorite.service';

const router = Router();

// GET /api/favorites
router.get('/', authenticate, async (req: Request, res: Response) => {
    try {
        const favorites = await favoriteService.listByUser(req.uid!);
        res.json({ success: true, data: favorites });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// POST /api/favorites/toggle
router.post('/toggle', authenticate, async (req: Request, res: Response) => {
    try {
        const { itemId, itemType, itemName, itemImage } = req.body;
        if (!itemId || !itemType) {
            res.status(400).json({ success: false, error: 'itemId and itemType required' }); return;
        }
        const result = await favoriteService.toggle(req.uid!, itemId, itemType, itemName || '', itemImage);
        res.json({ success: true, data: result });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// GET /api/favorites/check/:itemId
router.get('/check/:itemId', authenticate, async (req: Request, res: Response) => {
    try {
        const isFav = await favoriteService.isFavorite(req.uid!, req.params.itemId);
        res.json({ success: true, data: { isFavorite: isFav } });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
