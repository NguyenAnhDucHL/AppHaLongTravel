import { Router, Request, Response } from 'express';
import { searchService } from '../services/search.service';

const router = Router();

// GET /api/search?q=&type=
router.get('/', async (req: Request, res: Response) => {
    try {
        const q = req.query.q as string;
        if (!q || q.length < 2) {
            res.status(400).json({ success: false, error: 'Query must be at least 2 characters' }); return;
        }
        const type = req.query.type as string | undefined;
        const limit = parseInt(req.query.limit as string) || 20;
        const { results, total } = await searchService.search(q, type, limit);
        res.json({ success: true, data: results, total });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// GET /api/search/popular
router.get('/popular', async (_req: Request, res: Response) => {
    try {
        const popular = await searchService.getPopular();
        res.json({ success: true, data: popular });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
