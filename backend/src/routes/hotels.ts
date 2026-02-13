import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
import { validatePagination } from '../middleware/validation';
import { hotelService } from '../services/hotel.service';

const router = Router();

// GET /api/hotels
router.get('/', validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const filters = {
            category: req.query.category as string | undefined,
            minPrice: req.query.minPrice ? parseInt(req.query.minPrice as string) : undefined,
            maxPrice: req.query.maxPrice ? parseInt(req.query.maxPrice as string) : undefined,
            featured: req.query.featured === 'true',
        };
        const { items, total } = await hotelService.list(page, limit, filters);
        res.json({
            success: true,
            data: items,
            pagination: { page, limit, total, totalPages: Math.ceil(total / limit) },
        });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to fetch hotels';
        res.status(500).json({ success: false, error: msg });
    }
});

// GET /api/hotels/featured
router.get('/featured', async (_req: Request, res: Response) => {
    try {
        const hotels = await hotelService.getFeatured();
        res.json({ success: true, data: hotels });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to fetch featured hotels';
        res.status(500).json({ success: false, error: msg });
    }
});

// GET /api/hotels/:id
router.get('/:id', async (req: Request, res: Response) => {
    try {
        const hotel = await hotelService.getById(req.params.id);
        if (!hotel) { res.status(404).json({ success: false, error: 'Hotel not found' }); return; }
        res.json({ success: true, data: hotel });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to fetch hotel';
        res.status(500).json({ success: false, error: msg });
    }
});

// POST /api/hotels — Admin only
router.post('/', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const hotel = await hotelService.create(req.body);
        res.status(201).json({ success: true, data: hotel, message: 'Hotel created' });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to create hotel';
        res.status(500).json({ success: false, error: msg });
    }
});

// PUT /api/hotels/:id — Admin only
router.put('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await hotelService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Hotel updated' });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to update hotel';
        res.status(500).json({ success: false, error: msg });
    }
});

// DELETE /api/hotels/:id — Admin only
router.delete('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await hotelService.delete(req.params.id);
        res.json({ success: true, message: 'Hotel deleted' });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to delete hotel';
        res.status(500).json({ success: false, error: msg });
    }
});

export default router;
