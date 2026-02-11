"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middleware/auth");
const validation_1 = require("../middleware/validation");
const auth_service_1 = require("../services/auth.service");
const router = (0, express_1.Router)();
// POST /api/auth/register
router.post('/register', auth_1.authenticate, (0, validation_1.validateBody)(['displayName']), async (req, res) => {
    try {
        const { displayName, phone } = req.body;
        const user = await auth_service_1.authService.register(req.uid, req.userEmail, displayName, phone);
        res.status(201).json({ success: true, data: user });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Registration failed';
        res.status(500).json({ success: false, error: msg });
    }
});
// GET /api/auth/profile
router.get('/profile', auth_1.authenticate, async (req, res) => {
    try {
        const user = await auth_service_1.authService.getProfile(req.uid);
        if (!user) {
            res.status(404).json({ success: false, error: 'User not found' });
            return;
        }
        res.json({ success: true, data: user });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to get profile';
        res.status(500).json({ success: false, error: msg });
    }
});
// PUT /api/auth/profile
router.put('/profile', auth_1.authenticate, async (req, res) => {
    try {
        const user = await auth_service_1.authService.updateProfile(req.uid, req.body);
        res.json({ success: true, data: user });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to update profile';
        res.status(500).json({ success: false, error: msg });
    }
});
// DELETE /api/auth/profile
router.delete('/profile', auth_1.authenticate, async (req, res) => {
    try {
        await auth_service_1.authService.deleteAccount(req.uid);
        res.json({ success: true, message: 'Account deleted' });
    }
    catch (error) {
        const msg = error instanceof Error ? error.message : 'Failed to delete account';
        res.status(500).json({ success: false, error: msg });
    }
});
exports.default = router;
//# sourceMappingURL=auth.js.map