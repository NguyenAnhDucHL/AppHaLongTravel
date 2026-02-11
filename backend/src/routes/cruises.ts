import { Router, Request, Response } from 'express';
import { validatePagination } from '../middleware/validation';
import { cruiseService } from '../services/cruise.service';

const router = Router();

router.get('/', validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const { items, total } = await cruiseService.list(page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.get('/:id', async (req: Request, res: Response) => {
    try {
        const cruise = await cruiseService.getById(req.params.id);
        if (!cruise) { res.status(404).json({ success: false, error: 'Cruise not found' }); return; }
        res.json({ success: true, data: cruise });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
