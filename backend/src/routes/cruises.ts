import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
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

// POST /api/cruises — Admin only
router.post('/', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const cruise = await cruiseService.create(req.body);
        res.status(201).json({ success: true, data: cruise, message: 'Cruise created' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/cruises/:id — Admin only
router.put('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await cruiseService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Cruise updated' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// DELETE /api/cruises/:id — Admin only
router.delete('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await cruiseService.delete(req.params.id);
        res.json({ success: true, message: 'Cruise deleted' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
