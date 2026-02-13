import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
import { destinationService } from '../services/destination.service';

const router = Router();

router.get('/', async (_req: Request, res: Response) => {
    try {
        const destinations = await destinationService.list();
        res.json({ success: true, data: destinations });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.post('/', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const destination = await destinationService.create(req.body);
        res.status(201).json({ success: true, data: destination });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.put('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await destinationService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Destination updated' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.delete('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await destinationService.delete(req.params.id);
        res.json({ success: true, message: 'Destination deleted' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
