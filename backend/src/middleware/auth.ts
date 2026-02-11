import { Request, Response, NextFunction } from 'express';
import { auth } from '../config/firebase';
import { UserRole } from '../models/types';

// Extend Express Request to include user info
declare global {
    namespace Express {
        interface Request {
            uid?: string;
            userEmail?: string;
            userRole?: UserRole;
            assignedServices?: string[];
        }
    }
}

/**
 * Middleware to verify Firebase ID token from Authorization header
 */
export const authenticate = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        res.status(401).json({ success: false, error: 'No authentication token provided' });
        return;
    }

    const token = authHeader.split('Bearer ')[1];

    try {
        const decodedToken = await auth.verifyIdToken(token);
        req.uid = decodedToken.uid;
        req.userEmail = decodedToken.email;

        // Load user role from Firestore
        const { db } = await import('../config/firebase');
        const userDoc = await db.collection('users').doc(decodedToken.uid).get();
        const userData = userDoc.data();

        if (userData) {
            req.userRole = (userData.role as UserRole) || 'customer';
            req.assignedServices = userData.assignedServices || [];

            // Check if account is active
            if (userData.isActive === false) {
                res.status(403).json({ success: false, error: 'Account is disabled. Contact admin.' });
                return;
            }
        }

        next();
    } catch (error) {
        res.status(401).json({ success: false, error: 'Invalid or expired token' });
    }
};

/**
 * Optional auth — sets uid if token present, but doesn't block
 */
export const optionalAuth = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
        try {
            const token = authHeader.split('Bearer ')[1];
            const decodedToken = await auth.verifyIdToken(token);
            req.uid = decodedToken.uid;
            req.userEmail = decodedToken.email;

            const { db } = await import('../config/firebase');
            const userDoc = await db.collection('users').doc(decodedToken.uid).get();
            const userData = userDoc.data();
            if (userData) {
                req.userRole = (userData.role as UserRole) || 'customer';
                req.assignedServices = userData.assignedServices || [];
            }
        } catch {
            // Token invalid, continue without auth
        }
    }
    next();
};

/**
 * Flexible role-based middleware — accepts array of allowed roles
 * Usage: requireRole('admin'), requireRole('admin', 'collaborator')
 */
export const requireRole = (...allowedRoles: UserRole[]) => {
    return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
        if (!req.uid) {
            res.status(401).json({ success: false, error: 'Authentication required' });
            return;
        }

        if (!req.userRole) {
            res.status(403).json({ success: false, error: 'No role assigned' });
            return;
        }

        if (!allowedRoles.includes(req.userRole)) {
            res.status(403).json({
                success: false,
                error: `Access denied. Required role: ${allowedRoles.join(' or ')}. Your role: ${req.userRole}`,
            });
            return;
        }

        next();
    };
};

/**
 * Admin-only middleware — shorthand for requireRole('admin')
 */
export const requireAdmin = requireRole('admin');

/**
 * Check if user can manage a specific service
 * For collaborators, checks assignedServices. Admins always pass.
 */
export const requireServiceAccess = (serviceIdParam: string = 'id') => {
    return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
        if (!req.uid) {
            res.status(401).json({ success: false, error: 'Authentication required' });
            return;
        }

        // Admins can access everything
        if (req.userRole === 'admin') {
            next();
            return;
        }

        // Collaborators can only access assigned services
        if (req.userRole === 'collaborator') {
            const serviceId = req.params[serviceIdParam];
            if (req.assignedServices && req.assignedServices.includes(serviceId)) {
                next();
                return;
            }
            res.status(403).json({ success: false, error: 'You do not have access to this service' });
            return;
        }

        res.status(403).json({ success: false, error: 'Admin or collaborator access required' });
    };
};
