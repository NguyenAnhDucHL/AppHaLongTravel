"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const booking_service_1 = require("../services/booking.service");
const notification_service_1 = require("../services/notification.service");
const router = (0, express_1.Router)();
// GET /api/bookings
router.get('/', auth_1.authenticate, validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const status = req.query.status;
        const { items, total } = await booking_service_1.bookingService.listByUser(req.uid, status, page, limit);
        res.json({ success: true, data: items, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// GET /api/bookings/:id
router.get('/:id', auth_1.authenticate, async (req, res) => {
    try {
        const booking = await booking_service_1.bookingService.getById(req.params.id);
        if (!booking || booking.userId !== req.uid) {
            res.status(404).json({ success: false, error: 'Booking not found' });
            return;
        }
        res.json({ success: true, data: booking });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// POST /api/bookings
router.post('/', auth_1.authenticate, (0, validation_1.validateBody)(['itemId', 'itemType', 'itemName', 'checkIn', 'guests', 'totalPrice']), async (req, res) => {
    try {
        const booking = await booking_service_1.bookingService.create({
            ...req.body,
            userId: req.uid,
            status: 'pending',
            paymentStatus: 'pending',
        });
        // Send notification
        await notification_service_1.notificationService.create(req.uid, 'Booking Created', `Your booking for ${req.body.itemName} has been created.`, 'booking', { bookingId: booking.id });
        res.status(201).json({ success: true, data: booking });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/bookings/:id/cancel
router.put('/:id/cancel', auth_1.authenticate, async (req, res) => {
    try {
        const booking = await booking_service_1.bookingService.cancel(req.params.id, req.uid);
        if (!booking) {
            res.status(400).json({ success: false, error: 'Cannot cancel this booking' });
            return;
        }
        res.json({ success: true, data: booking, message: 'Booking cancelled' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=bookings.js.map