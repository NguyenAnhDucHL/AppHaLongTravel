import * as admin from 'firebase-admin';

admin.initializeApp();

export const db = admin.firestore();
export const auth = admin.auth();
export const storage = admin.storage();

// Collection references
export const Collections = {
    USERS: 'users',
    HOTELS: 'hotels',
    CRUISES: 'cruises',
    TOURS: 'tours',
    RESTAURANTS: 'restaurants',
    TRANSPORT: 'transport',
    BOOKINGS: 'bookings',
    REVIEWS: 'reviews',
    FAVORITES: 'favorites',
    NOTIFICATIONS: 'notifications',
    PAYMENTS: 'payments',
    PAYMENT_METHODS: 'payment_methods',
} as const;
