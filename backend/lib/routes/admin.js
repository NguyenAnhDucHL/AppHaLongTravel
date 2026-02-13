"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const booking_service_1 = require("../services/booking.service");
const auth_service_1 = require("../services/auth.service");
const review_service_1 = require("../services/review.service");
const firebase_1 = require("../config/firebase");
const seed_data_1 = require("../seed/seed-data");
const router = (0, express_1.Router)();
// GET /api/admin/stats — Admin + Collaborator
router.get('/stats', auth_1.authenticate, (0, auth_1.requireRole)('admin', 'collaborator'), async (_req, res) => {
    try {
        const [users, hotels, cruises, tours, restaurants, bookings, reviews] = await Promise.all([
            firebase_1.db.collection(firebase_1.Collections.USERS).count().get(),
            firebase_1.db.collection(firebase_1.Collections.HOTELS).count().get(),
            firebase_1.db.collection(firebase_1.Collections.CRUISES).count().get(),
            firebase_1.db.collection(firebase_1.Collections.TOURS).count().get(),
            firebase_1.db.collection(firebase_1.Collections.RESTAURANTS).count().get(),
            firebase_1.db.collection(firebase_1.Collections.BOOKINGS).count().get(),
            firebase_1.db.collection(firebase_1.Collections.REVIEWS).count().get(),
        ]);
        // Revenue from completed bookings
        const completedBookings = await firebase_1.db.collection(firebase_1.Collections.BOOKINGS)
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
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/admin/bookings — Admin only
router.get('/bookings', auth_1.authenticate, (0, auth_1.requireRole)('admin'), validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const { items, total } = await booking_service_1.bookingService.listAll(page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/admin/bookings/:id — Admin only
router.put('/bookings/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const { status } = req.body;
        if (!status) {
            res.status(400).json({ success: false, error: 'status required' });
            return;
        }
        await booking_service_1.bookingService.updateStatus(req.params.id, status);
        res.json({ success: true, message: 'Booking status updated' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// ===== USER MANAGEMENT (Admin only) =====
// GET /api/admin/users — List all users with optional role filter
router.get('/users', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const role = req.query.role;
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 20;
        const result = await auth_service_1.authService.listUsers(role, page, limit);
        res.json({
            success: true,
            data: result.users,
            pagination: { page, limit, total: result.total, totalPages: Math.ceil(result.total / limit) },
        });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/admin/users/stats — User stats by role
router.get('/users/stats', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (_req, res) => {
    try {
        const stats = await auth_service_1.authService.getUserStats();
        res.json({ success: true, data: stats });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/admin/users/:id/role — Change user role
router.put('/users/:id/role', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const { role, assignedServices } = req.body;
        if (!role) {
            res.status(400).json({ success: false, error: 'role is required' });
            return;
        }
        const validRoles = ['admin', 'collaborator', 'customer', 'guest'];
        if (!validRoles.includes(role)) {
            res.status(400).json({ success: false, error: `Invalid role. Must be one of: ${validRoles.join(', ')}` });
            return;
        }
        // Prevent self-demotion
        if (req.params.id === req.uid && role !== 'admin') {
            res.status(400).json({ success: false, error: 'Cannot change your own role' });
            return;
        }
        const user = await auth_service_1.authService.setUserRole(req.params.id, role, assignedServices);
        res.json({ success: true, data: user, message: `Role updated to ${role}` });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/admin/users/:id/status — Enable/disable user
router.put('/users/:id/status', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
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
        const user = await auth_service_1.authService.setUserActive(req.params.id, isActive);
        res.json({ success: true, data: user, message: isActive ? 'Account enabled' : 'Account disabled' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/admin/users/:id/assign — Assign services to collaborator
router.put('/users/:id/assign', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        const { serviceIds } = req.body;
        if (!Array.isArray(serviceIds)) {
            res.status(400).json({ success: false, error: 'serviceIds (array) is required' });
            return;
        }
        const user = await auth_service_1.authService.assignServices(req.params.id, serviceIds);
        res.json({ success: true, data: user, message: 'Services assigned' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// DELETE /api/admin/users/:id — Delete user (admin only)
router.delete('/users/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        if (req.params.id === req.uid) {
            res.status(400).json({ success: false, error: 'Cannot delete your own account' });
            return;
        }
        await auth_service_1.authService.deleteAccount(req.params.id);
        res.json({ success: true, message: 'User deleted' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// ===== REVIEW MANAGEMENT (Admin/Collaborator) =====
// GET /api/admin/reviews — List all reviews
router.get('/reviews', auth_1.authenticate, (0, auth_1.requireRole)('admin', 'collaborator'), validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const { items, total } = await review_service_1.reviewService.listAll(page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/admin/reviews/:id/status — Approve/Reject review
router.put('/reviews/:id/status', auth_1.authenticate, (0, auth_1.requireRole)('admin', 'collaborator'), async (req, res) => {
    try {
        const { status } = req.body;
        if (!['approved', 'rejected', 'pending'].includes(status)) {
            res.status(400).json({ success: false, error: 'Invalid status' });
            return;
        }
        await review_service_1.reviewService.updateStatus(req.params.id, status);
        res.json({ success: true, message: 'Review status updated' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// DELETE /api/admin/reviews/:id — Delete review
router.delete('/reviews/:id', auth_1.authenticate, (0, auth_1.requireRole)('admin'), async (req, res) => {
    try {
        await review_service_1.reviewService.delete(req.params.id);
        res.json({ success: true, message: 'Review deleted' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// Seed database (Admin only - or open for first run if needed, currently protected)
// curl -X POST https://<region>-<project>.cloudfunctions.net/api/api/admin/seed -H "Authorization: Bearer <token>"
router.post('/seed', async (req, res) => {
    try {
        const results = await (0, seed_data_1.seedDatabase)(firebase_1.db);
        res.json({ success: true, results });
    }
    catch (error) {
        res.status(500).json({ success: false, error: 'Seed failed', details: error });
    }
});
exports.default = router;
//# sourceMappingURL=admin.js.map