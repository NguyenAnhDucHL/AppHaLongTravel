"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ROLE_PERMISSIONS = void 0;
exports.ROLE_PERMISSIONS = {
    admin: ['*'], // Full access
    collaborator: ['manage_assigned_services', 'view_bookings', 'respond_reviews', 'view_stats'],
    customer: ['book_services', 'write_reviews', 'manage_favorites', 'view_bookings'],
    guest: ['view_services'],
};
//# sourceMappingURL=types.js.map