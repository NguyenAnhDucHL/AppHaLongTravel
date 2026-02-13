import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
import { dealService } from '../services/deal.service';

const router = Router();

router.get('/', async (_req: Request, res: Response) => {
    try {
        const deals = await dealService.list();
        res.json({ success: true, data: deals });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.post('/', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const deal = await dealService.create(req.body);
        res.status(201).json({ success: true, data: deal });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.put('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await dealService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Deal updated' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.delete('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await dealService.delete(req.params.id);
        res.json({ success: true, message: 'Deal deleted' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
