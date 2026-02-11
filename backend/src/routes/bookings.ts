import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import { validateBody, validatePagination } from '../middleware/validation';
import { bookingService } from '../services/booking.service';
import { notificationService } from '../services/notification.service';
import { BookingStatus } from '../models/types';

const router = Router();

// GET /api/bookings
router.get('/', authenticate, validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const status = req.query.status as BookingStatus | undefined;
        const { items, total } = await bookingService.listByUser(req.uid!, status, page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// GET /api/bookings/:id
router.get('/:id', authenticate, async (req: Request, res: Response) => {
    try {
        const booking = await bookingService.getById(req.params.id);
        if (!booking || booking.userId !== req.uid) {
            res.status(404).json({ success: false, error: 'Booking not found' }); return;
        }
        res.json({ success: true, data: booking });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// POST /api/bookings
router.post('/', authenticate, validateBody(['itemId', 'itemType', 'itemName', 'checkIn', 'guests', 'totalPrice']), async (req: Request, res: Response) => {
    try {
        const booking = await bookingService.create({
            ...req.body,
            userId: req.uid!,
            status: 'pending',
            paymentStatus: 'pending',
        });

        // Send notification
        await notificationService.create(
            req.uid!,
            'Booking Created',
            `Your booking for ${req.body.itemName} has been created.`,
            'booking',
            { bookingId: booking.id }
        );

        res.status(201).json({ success: true, data: booking });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/bookings/:id/cancel
router.put('/:id/cancel', authenticate, async (req: Request, res: Response) => {
    try {
        const booking = await bookingService.cancel(req.params.id, req.uid!);
        if (!booking) {
            res.status(400).json({ success: false, error: 'Cannot cancel this booking' }); return;
        }
        res.json({ success: true, data: booking, message: 'Booking cancelled' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
