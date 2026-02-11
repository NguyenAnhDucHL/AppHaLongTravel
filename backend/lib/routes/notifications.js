"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const notification_service_1 = require("../services/notification.service");
const router = (0, express_1.Router)();
// GET /api/notifications
router.get('/', auth_1.authenticate, validation_1.validatePagination, async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = parseInt(req.query.limit);
        const { items, total, unread } = await notification_service_1.notificationService.listByUser(req.uid, page, limit);
        res.json({
            success: true,
            data: items,
            unread,
            pagination: { page, limit, total, totalPages: Math.ceil(total / limit) },
        });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/notifications/read-all
router.put('/read-all', auth_1.authenticate, async (req, res) => {
    try {
        const count = await notification_service_1.notificationService.markAllRead(req.uid);
        res.json({ success: true, message: `${count} notifications marked as read` });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// PUT /api/notifications/:id/read
router.put('/:id/read', auth_1.authenticate, async (req, res) => {
    try {
        await notification_service_1.notificationService.markAsRead(req.params.id);
        res.json({ success: true, message: 'Notification marked as read' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=notifications.js.map