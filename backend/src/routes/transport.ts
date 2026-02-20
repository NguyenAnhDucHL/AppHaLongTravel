import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
import { validateBody } from '../middleware/validation';
import { transportService } from '../services/transport.service';

const router = Router();

router.get('/vehicles', async (_req: Request, res: Response) => {
    try {
        const vehicles = await transportService.listVehicles();
        res.json({ success: true, data: vehicles });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

router.get('/estimate', async (req: Request, res: Response) => {
    try {
        const vehicleType = req.query.vehicleType as string;
        const distanceKm = parseFloat(req.query.distanceKm as string);
        if (!vehicleType || isNaN(distanceKm)) {
            res.status(400).json({ success: false, error: 'vehicleType and distanceKm required' }); return;
        }
        const estimate = await transportService.estimatePrice(vehicleType, distanceKm);
        res.json({ success: true, data: estimate });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/transport/admin/all — Admin only
router.get('/admin/all', authenticate, requireRole('admin'), async (_req: Request, res: Response) => {
    try {
        const vehicles = await transportService.listAll();
        res.json({ success: true, data: vehicles });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// POST /api/transport — Admin only
router.post('/', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const transport = await transportService.create(req.body);
        res.status(201).json({ success: true, data: transport, message: 'Transport created' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/transport/:id — Admin only
router.put('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await transportService.update(req.params.id, req.body);
        res.json({ success: true, message: 'Transport updated' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// DELETE /api/transport/:id — Admin only
router.delete('/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        await transportService.delete(req.params.id);
        res.json({ success: true, message: 'Transport deleted' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
