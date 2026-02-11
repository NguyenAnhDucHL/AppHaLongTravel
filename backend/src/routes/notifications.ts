import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import { validatePagination } from '../middleware/validation';
import { notificationService } from '../services/notification.service';

const router = Router();

// GET /api/notifications
router.get('/', authenticate, validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const { items, total, unread } = await notificationService.listByUser(req.uid!, page, limit);
        res.json({
            success: true,
            data: items,
            unread,
            pagination: { page, limit, total, totalPages: Math.ceil(total / limit) },
        });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/notifications/read-all
router.put('/read-all', authenticate, async (req: Request, res: Response) => {
    try {
        const count = await notificationService.markAllRead(req.uid!);
        res.json({ success: true, message: `${count} notifications marked as read` });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/notifications/:id/read
router.put('/:id/read', authenticate, async (req: Request, res: Response) => {
    try {
        await notificationService.markAsRead(req.params.id);
        res.json({ success: true, message: 'Notification marked as read' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

export default router;
