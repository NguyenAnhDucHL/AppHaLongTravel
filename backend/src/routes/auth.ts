import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import { validateBody } from '../middleware/validation';
import { authService } from '../services/auth.service';

const router = Router();

// POST /api/auth/register
router.post('/register', authenticate, validateBody(['displayName']), async (req: Request, res: Response) => {
    try {
        const { displayName, phone } = req.body;
        const user = await authService.register(req.uid!, req.userEmail!, displayName, phone);
        res.status(201).json({ success: true, data: user });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Registration failed';
        res.status(500).json({ success: false, error: msg });
    }
});

// GET /api/auth/profile
router.get('/profile', authenticate, async (req: Request, res: Response) => {
    try {
        const user = await authService.getProfile(req.uid!);
        if (!user) { res.status(404).json({ success: false, error: 'User not found' }); return; }
        res.json({ success: true, data: user });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to get profile';
        res.status(500).json({ success: false, error: msg });
    }
});

// PUT /api/auth/profile
router.put('/profile', authenticate, async (req: Request, res: Response) => {
    try {
        const user = await authService.updateProfile(req.uid!, req.body);
        res.json({ success: true, data: user });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to update profile';
        res.status(500).json({ success: false, error: msg });
    }
});

// DELETE /api/auth/profile
router.delete('/profile', authenticate, async (req: Request, res: Response) => {
    try {
        await authService.deleteAccount(req.uid!);
        res.json({ success: true, message: 'Account deleted' });
    } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : 'Failed to delete account';
        res.status(500).json({ success: false, error: msg });
    }
});

export default router;
