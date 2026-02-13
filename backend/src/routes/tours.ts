import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
import { validatePagination } from '../middleware/validation';
import { tourService } from '../services/tour.service';

const router = Router();

router.get('/', validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const difficulty = req.query.difficulty as string | undefined;
        const { items, total } = await tourService.list(page, limit, difficulty);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.get('/:id', async (req: Request, res: Response) => {
    try {
        const tour = await tourService.getById(req.params.id);
        if (!tour) { res.status(404).json({ success: false, error: 'Tour not found' }); return; }
        res.json({ success: true, data: tour });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// POST /api/tours — Admin only
router.post('/', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const tour = await tourService.create(req.body);
        res.status(201).json({ success: true, data: tour, message: 'Tour created' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/tours/:id — Admin only
router.put('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await tourService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Tour updated' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// DELETE /api/tours/:id — Admin only
router.delete('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await tourService.delete(req.params.id);
        res.json({ success: true, message: 'Tour deleted' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
