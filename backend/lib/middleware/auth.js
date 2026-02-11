"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.requireServiceAccess = exports.requireAdmin = exports.requireRole = exports.optionalAuth = exports.authenticate = void 0;
const firebase_1 = require("../config/firebase");
/**
 * Middleware to verify Firebase ID token from Authorization header
 */
const authenticate = async (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        res.status(401).json({ success: false, error: 'No authentication token provided' });
        return;
    }
    const token = authHeader.split('Bearer ')[1];
    try {
        const decodedToken = await firebase_1.auth.verifyIdToken(token);
        req.uid = decodedToken.uid;
        req.userEmail = decodedToken.email;
        // Load user role from Firestore
        const { db } = await Promise.resolve().then(() => __importStar(require('../config/firebase')));
        const userDoc = await db.collection('users').doc(decodedToken.uid).get();
        const userData = userDoc.data();
        if (userData) {
            req.userRole = userData.role || 'customer';
            req.assignedServices = userData.assignedServices || [];
            // Check if account is active
            if (userData.isActive === false) {
                res.status(403).json({ success: false, error: 'Account is disabled. Contact admin.' });
                return;
            }
        }
        next();
    }
    catch (error) {
        res.status(401).json({ success: false, error: 'Invalid or expired token' });
    }
};
exports.authenticate = authenticate;
/**
 * Optional auth — sets uid if token present, but doesn't block
 */
const optionalAuth = async (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
        try {
            const token = authHeader.split('Bearer ')[1];
            const decodedToken = await firebase_1.auth.verifyIdToken(token);
            req.uid = decodedToken.uid;
            req.userEmail = decodedToken.email;
            const { db } = await Promise.resolve().then(() => __importStar(require('../config/firebase')));
            const userDoc = await db.collection('users').doc(decodedToken.uid).get();
            const userData = userDoc.data();
            if (userData) {
                req.userRole = userData.role || 'customer';
                req.assignedServices = userData.assignedServices || [];
            }
        }
        catch {
            // Token invalid, continue without auth
        }
    }
    next();
};
exports.optionalAuth = optionalAuth;
/**
 * Flexible role-based middleware — accepts array of allowed roles
 * Usage: requireRole('admin'), requireRole('admin', 'collaborator')
 */
const requireRole = (...allowedRoles) => {
    return async (req, res, next) => {
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
exports.requireRole = requireRole;
/**
 * Admin-only middleware — shorthand for requireRole('admin')
 */
exports.requireAdmin = (0, exports.requireRole)('admin');
/**
 * Check if user can manage a specific service
 * For collaborators, checks assignedServices. Admins always pass.
 */
const requireServiceAccess = (serviceIdParam = 'id') => {
    return async (req, res, next) => {
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
exports.requireServiceAccess = requireServiceAccess;
//# sourceMappingURL=auth.js.map