import { Router, Request, Response } from 'express';
import { validatePagination } from '../middleware/validation';
import { restaurantService } from '../services/restaurant.service';

const router = Router();

router.get('/', validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const cuisine = req.query.cuisine as string | undefined;
        const { items, total } = await restaurantService.list(page, limit, cuisine);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.get('/:id', async (req: Request, res: Response) => {
    try {
        const restaurant = await restaurantService.getById(req.params.id);
        if (!restaurant) { res.status(404).json({ success: false, error: 'Restaurant not found' }); return; }
        res.json({ success: true, data: restaurant });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
