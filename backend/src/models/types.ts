import { Timestamp } from 'firebase-admin/firestore';

// ===== User Roles =====
export type UserRole = 'admin' | 'collaborator' | 'customer' | 'guest';

export const ROLE_PERMISSIONS: Record<UserRole, string[]> = {
    admin: ['*'], // Full access
    collaborator: ['manage_assigned_services', 'view_bookings', 'respond_reviews', 'view_stats'],
    customer: ['book_services', 'write_reviews', 'manage_favorites', 'view_bookings'],
    guest: ['view_services'],
};

// ===== User =====
export interface User {
    id: string;
    email: string;
    displayName: string;
    phone?: string;
    avatar?: string;
    bio?: string;
    gender?: 'male' | 'female' | 'other';
    role: UserRole;
    permissions?: string[];
    assignedServices?: string[]; // For collaborators: IDs of services they manage
    isActive: boolean;
    language: string;
    currency: string;
    darkMode: boolean;
    createdAt: Timestamp;
    updatedAt: Timestamp;
}

// ===== Hotel =====
export interface HotelRoom {
    type: string;
    price: number;
    capacity: number;
    available: number;
    description: string;
}

export interface Hotel {
    id: string;
    name: string;
    description: string;
    location: string;
    address: string;
    lat: number;
    lng: number;
    rating: number;
    reviewCount: number;
    pricePerNight: number;
    currency: string;
    amenities: string[];
    images: string[];
    category: string;
    featured: boolean;
    rooms: HotelRoom[];
    createdAt: Timestamp;
}

// ===== Cruise =====
export interface CabinType {
    name: string;
    price: number;
    capacity: number;
    description: string;
    amenities: string[];
}

export interface ItineraryItem {
    time: string;
    title: string;
    description: string;
}

export interface Cruise {
    id: string;
    name: string;
    description: string;
    duration: string;
    route: string;
    rating: number;
    reviewCount: number;
    pricePerPerson: number;
    highlights: string[];
    itinerary: ItineraryItem[];
    cabinTypes: CabinType[];
    images: string[];
    included: string[];
    excluded: string[];
    createdAt: Timestamp;
}

// ===== Tour =====
export interface TourSchedule {
    day: number;
    title: string;
    description: string;
}

export interface TourGuide {
    name: string;
    avatar: string;
    experience: string;
    languages: string[];
}

export interface Tour {
    id: string;
    name: string;
    description: string;
    duration: string;
    difficulty: 'easy' | 'moderate' | 'hard';
    rating: number;
    reviewCount: number;
    pricePerPerson: number;
    groupSize: number;
    schedule: TourSchedule[];
    guide: TourGuide;
    images: string[];
    createdAt: Timestamp;
}

// ===== Restaurant =====
export interface MenuItem {
    name: string;
    price: number;
    description: string;
    category: string;
    popular: boolean;
}

export interface Restaurant {
    id: string;
    name: string;
    description: string;
    cuisine: string[];
    address: string;
    lat: number;
    lng: number;
    rating: number;
    reviewCount: number;
    priceRange: string;
    popularDishes: string[];
    menu: MenuItem[];
    contactInfo: { phone: string; email?: string; website?: string };
    images: string[];
    openingHours: string;
    createdAt: Timestamp;
}

// ===== Transport =====
export interface Transport {
    id: string;
    vehicleType: string;
    capacity: number;
    pricePerKm: number;
    available: boolean;
    driver?: string;
    licensePlate?: string;
    description: string;
    image?: string;
}

// ===== Booking =====
export type BookingStatus = 'pending' | 'confirmed' | 'completed' | 'cancelled';
export type ItemType = 'hotel' | 'cruise' | 'tour' | 'restaurant' | 'transport';

export interface GuestInfo {
    name: string;
    email: string;
    phone: string;
}

export interface Booking {
    id: string;
    userId: string;
    itemId: string;
    itemType: ItemType;
    itemName: string;
    checkIn: string;
    checkOut?: string;
    guests: number;
    totalPrice: number;
    currency: string;
    status: BookingStatus;
    paymentMethod: string;
    paymentStatus: 'pending' | 'paid' | 'refunded';
    guestInfo: GuestInfo;
    createdAt: Timestamp;
    updatedAt: Timestamp;
}

// ===== Review =====
export interface AspectRatings {
    cleanliness: number;
    service: number;
    location: number;
    value: number;
}

export interface Review {
    id: string;
    userId: string;
    userName: string;
    userAvatar?: string;
    itemId: string;
    itemType: ItemType;
    rating: number;
    text: string;
    photos: string[];
    aspectRatings: AspectRatings;
    createdAt: Timestamp;
}

// ===== Favorite =====
export interface Favorite {
    id: string;
    userId: string;
    itemId: string;
    itemType: ItemType;
    itemName: string;
    itemImage?: string;
    createdAt: Timestamp;
}

// ===== Notification =====
export interface Notification {
    id: string;
    userId: string;
    title: string;
    body: string;
    type: 'booking' | 'promotion' | 'system' | 'review';
    read: boolean;
    data?: Record<string, string>;
    createdAt: Timestamp;
}

// ===== Payment =====
export interface PaymentMethod {
    id: string;
    userId: string;
    type: string; // visa, momo, vnpay, zalopay, bank_transfer
    last4: string;
    expiry?: string;
    isDefault: boolean;
    createdAt: Timestamp;
}

export interface Payment {
    id: string;
    userId: string;
    bookingId: string;
    amount: number;
    currency: string;
    method: string;
    status: 'pending' | 'completed' | 'failed' | 'refunded';
    transactionId?: string;
    createdAt: Timestamp;
}

// ===== API Response =====
export interface ApiResponse<T = unknown> {
    success: boolean;
    data?: T;
    error?: string;
    message?: string;
    pagination?: {
        page: number;
        limit: number;
        total: number;
        totalPages: number;
    };
}
