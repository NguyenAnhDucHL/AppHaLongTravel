import { Request, Response, NextFunction } from 'express';

/**
 * Validate required fields in request body
 */
export const validateBody = (requiredFields: string[]) => {
    return (req: Request, res: Response, next: NextFunction): void => {
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

/**
 * Validate query pagination params, set defaults
 */
export const validatePagination = (req: Request, _res: Response, next: NextFunction): void => {
    const page = parseInt(req.query.page as string) || 1;
    const limit = Math.min(parseInt(req.query.limit as string) || 20, 100);

    req.query.page = String(page);
    req.query.limit = String(limit);
    next();
};
