import { Router, Request, Response } from 'express';
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

export default router;
