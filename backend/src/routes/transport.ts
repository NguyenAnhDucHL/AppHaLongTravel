import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
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

export default router;
