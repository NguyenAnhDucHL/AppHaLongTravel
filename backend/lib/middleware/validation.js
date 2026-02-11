"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validatePagination = exports.validateBody = void 0;
/**
 * Validate required fields in request body
 */
const validateBody = (requiredFields) => {
    return (req, res, next) => {
        const missing = requiredFields.filter((field) => {
            const value = req.body[field];
            return value === undefined || value === null || value === '';
        });
        if (missing.length > 0) {
            res.status(400).json({
                success: false,
                error: `Missing required fields: ${missing.join(', ')}`,
            });
            return;
        }
        next();
    };
};
exports.validateBody = validateBody;
/**
 * Validate query pagination params, set defaults
 */
const validatePagination = (req, _res, next) => {
    const page = parseInt(req.query.page) || 1;
    const limit = Math.min(parseInt(req.query.limit) || 20, 100);
    req.query.page = String(page);
    req.query.limit = String(limit);
    next();
};
exports.validatePagination = validatePagination;
//# sourceMappingURL=validation.js.map