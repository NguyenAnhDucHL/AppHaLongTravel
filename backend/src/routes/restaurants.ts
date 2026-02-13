import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
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

// POST /api/restaurants — Admin only
router.post('/', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const restaurant = await restaurantService.create(req.body);
        res.status(201).json({ success: true, data: restaurant, message: 'Restaurant created' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/restaurants/:id — Admin only
router.put('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await restaurantService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Restaurant updated' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// DELETE /api/restaurants/:id — Admin only
router.delete('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await restaurantService.delete(req.params.id);
        res.json({ success: true, message: 'Restaurant deleted' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
