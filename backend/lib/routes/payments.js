"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const payment_service_1 = require("../services/payment.service");
const router = (0, express_1.Router)();
// GET /api/payments/methods
router.get('/methods', auth_1.authenticate, async (req, res) => {
    try {
        const methods = await payment_service_1.paymentService.listMethods(req.uid);
        res.json({ success: true, data: methods });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// POST /api/payments/methods
router.post('/methods', auth_1.authenticate, (0, validation_1.validateBody)(['type', 'last4']), async (req, res) => {
    try {
        const method = await payment_service_1.paymentService.addMethod(req.uid, req.body);
        res.status(201).json({ success: true, data: method });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// DELETE /api/payments/methods/:id
router.delete('/methods/:id', auth_1.authenticate, async (req, res) => {
    try {
        const deleted = await payment_service_1.paymentService.removeMethod(req.params.id, req.uid);
        if (!deleted) {
            res.status(404).json({ success: false, error: 'Payment method not found' });
            return;
        }
        res.json({ success: true, message: 'Payment method removed' });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
// POST /api/payments/process
router.post('/process', auth_1.authenticate, (0, validation_1.validateBody)(['bookingId', 'amount', 'method']), async (req, res) => {
    try {
        const { bookingId, amount, method } = req.body;
        const payment = await payment_service_1.paymentService.processPayment(req.uid, bookingId, amount, method);
        res.json({ success: true, data: payment });
    }
    catch (error) {
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : 'Failed' });
    }
});
exports.default = router;
//# sourceMappingURL=payments.js.map