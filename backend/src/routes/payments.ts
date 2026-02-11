import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import { validateBody } from '../middleware/validation';
import { paymentService } from '../services/payment.service';

const router = Router();

// GET /api/payments/methods
router.get('/methods', authenticate, async (req: Request, res: Response) => {
    try {
        const methods = await paymentService.listMethods(req.uid!);
        res.json({ success: true, data: methods });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// POST /api/payments/methods
router.post('/methods', authenticate, validateBody(['type', 'last4']), async (req: Request, res: Response) => {
    try {
        const method = await paymentService.addMethod(req.uid!, req.body);
        res.status(201).json({ success: true, data: method });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// DELETE /api/payments/methods/:id
router.delete('/methods/:id', authenticate, async (req: Request, res: Response) => {
    try {
        const deleted = await paymentService.removeMethod(req.params.id, req.uid!);
        if (!deleted) { res.status(404).json({ success: false, error: 'Payment method not found' }); return; }
        res.json({ success: true, message: 'Payment method removed' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// POST /api/payments/process
router.post('/process', authenticate, validateBody(['bookingId', 'amount', 'method']), async (req: Request, res: Response) => {
    try {
        const { bookingId, amount, method } = req.body;
        const payment = await paymentService.processPayment(req.uid!, bookingId, amount, method);
        res.json({ success: true, data: payment });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
