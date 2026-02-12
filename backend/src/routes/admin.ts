import { Router, Request, Response } from 'express';
import { authenticate, requireRole } from '../middleware/auth';
import { validatePagination } from '../middleware/validation';
import { bookingService } from '../services/booking.service';
import { authService } from '../services/auth.service';
import { db, Collections } from '../config/firebase';
import { seedDatabase } from '../seed/seed-data';
import { BookingStatus, UserRole } from '../models/types';

const router = Router();

// GET /api/admin/stats — Admin + Collaborator
router.get('/stats', authenticate, requireRole('admin', 'collaborator'), async (_req: Request, res: Response) => {
    try {
        const [users, hotels, cruises, tours, restaurants, bookings, reviews] = await Promise.all([
            db.collection(Collections.USERS).count().get(),
            db.collection(Collections.HOTELS).count().get(),
            db.collection(Collections.CRUISES).count().get(),
            db.collection(Collections.TOURS).count().get(),
            db.collection(Collections.RESTAURANTS).count().get(),
            db.collection(Collections.BOOKINGS).count().get(),
            db.collection(Collections.REVIEWS).count().get(),
        ]);

        // Revenue from completed bookings
        const completedBookings = await db.collection(Collections.BOOKINGS)
            .where('status', '==', 'completed')
            .get();
        const totalRevenue = completedBookings.docs.reduce((sum, doc) => sum + (doc.data().totalPrice || 0), 0);

        res.json({
            success: true,
            data: {
                users: users.data().count,
                hotels: hotels.data().count,
                cruises: cruises.data().count,
                tours: tours.data().count,
                restaurants: restaurants.data().count,
                bookings: bookings.data().count,
                reviews: reviews.data().count,
                totalRevenue,
            },
        });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// GET /api/admin/bookings — Admin only
router.get('/bookings', authenticate, requireRole('admin'), validatePagination, async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string);
        const limit = parseInt(req.query.limit as string);
        const { items, total } = await bookingService.listAll(page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/admin/bookings/:id — Admin only
router.put('/bookings/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const { status } = req.body;
        if (!status) { res.status(400).json({ success: false, error: 'status required' }); return; }
        await bookingService.updateStatus(req.params.id, status as BookingStatus);
        res.json({ success: true, message: 'Booking status updated' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// ===== USER MANAGEMENT (Admin only) =====

// GET /api/admin/users — List all users with optional role filter
router.get('/users', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const role = req.query.role as UserRole | undefined;
        const page = parseInt(req.query.page as string) || 1;
        const limit = parseInt(req.query.limit as string) || 20;
        const result = await authService.listUsers(role, page, limit);
        res.json({
            success: true,
            data: result.users,
            pagination: { page, limit, total: result.total, totalPages: Math.ceil(result.total / limit) },
        });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// GET /api/admin/users/stats — User stats by role
router.get('/users/stats', authenticate, requireRole('admin'), async (_req: Request, res: Response) => {
    try {
        const stats = await authService.getUserStats();
        res.json({ success: true, data: stats });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/admin/users/:id/role — Change user role
router.put('/users/:id/role', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const { role, assignedServices } = req.body;
        if (!role) {
            res.status(400).json({ success: false, error: 'role is required' });
            return;
        }
        const validRoles: UserRole[] = ['admin', 'collaborator', 'customer', 'guest'];
        if (!validRoles.includes(role)) {
            res.status(400).json({ success: false, error: `Invalid role. Must be one of: ${validRoles.join(', ')}` });
            return;
        }

        // Prevent self-demotion
        if (req.params.id === req.uid && role !== 'admin') {
            res.status(400).json({ success: false, error: 'Cannot change your own role' });
            return;
        }

        const user = await authService.setUserRole(req.params.id, role, assignedServices);
        res.json({ success: true, data: user, message: `Role updated to ${role}` });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/admin/users/:id/status — Enable/disable user
router.put('/users/:id/status', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const { isActive } = req.body;
        if (typeof isActive !== 'boolean') {
            res.status(400).json({ success: false, error: 'isActive (boolean) is required' });
            return;
        }

        // Prevent self-disable
        if (req.params.id === req.uid) {
            res.status(400).json({ success: false, error: 'Cannot disable your own account' });
            return;
        }

        const user = await authService.setUserActive(req.params.id, isActive);
        res.json({ success: true, data: user, message: isActive ? 'Account enabled' : 'Account disabled' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// PUT /api/admin/users/:id/assign — Assign services to collaborator
router.put('/users/:id/assign', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        const { serviceIds } = req.body;
        if (!Array.isArray(serviceIds)) {
            res.status(400).json({ success: false, error: 'serviceIds (array) is required' });
            return;
        }
        const user = await authService.assignServices(req.params.id, serviceIds);
        res.json({ success: true, data: user, message: 'Services assigned' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// DELETE /api/admin/users/:id — Delete user (admin only)
router.delete('/users/:id', authenticate, requireRole('admin'), async (req: Request, res: Response) => {
    try {
        if (req.params.id === req.uid) {
            res.status(400).json({ success: false, error: 'Cannot delete your own account' });
            return;
        }
        await authService.deleteAccount(req.params.id);
        res.json({ success: true, message: 'User deleted' });
    } catch (error: unknown) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});

// Seed database (Admin only - or open for first run if needed, currently protected)
// curl -X POST https://<region>-<project>.cloudfunctions.net/api/api/admin/seed -H "Authorization: Bearer <token>"
router.post('/seed', async (req, res) => {
    try {
        const results = await seedDatabase(db);
        res.json({ success: true, results });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Seed failed', details: error });
    }
});

export default router;
