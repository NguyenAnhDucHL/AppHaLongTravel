import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import { validateBody, validatePagination } from '../middleware/validation';
import { reviewService } from '../services/review.service';

const router = Router();

// POST /api/reviews
router.post('/', authenticate, validateBody(['itemId', 'itemType', 'rating', 'text']), async (req: Request, res: Response) => {
    try {
        const review = await reviewService.create({
            ...req.body,
            userId: req.uid!,
            userName: req.body.userName || 'Anonymous',
            photos: req.body.photos || [],
            aspectRatings: req.body.aspectRatings || { cleanliness: 0, service: 0, location: 0, value: 0 },
        });
        res.status(201).json({ success: true, data: review });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// GET /api/reviews/my
router.get('/my', authenticate, async (req: Request, res: Response) => {
    try {
        const reviews = await reviewService.listByUser(req.uid!);
        res.json({ success: true, data: reviews });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// GET /api/reviews/item/:itemType/:itemId
router.get('/item/:itemType/:itemId', validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const { items, total } = await reviewService.listByItem(req.params.itemId, req.params.itemType, page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
