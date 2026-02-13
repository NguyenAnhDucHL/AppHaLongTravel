import * as functions from 'firebase-functions';
import express from 'express';
import cors from 'cors';
import authRoutes from './routes/auth';
import hotelRoutes from './routes/hotels';
import cruiseRoutes from './routes/cruises';
import tourRoutes from './routes/tours';
import restaurantRoutes from './routes/restaurants';
import transportRoutes from './routes/transport';
import bookingRoutes from './routes/bookings';
import reviewRoutes from './routes/reviews';
import favoriteRoutes from './routes/favorites';
import notificationRoutes from './routes/notifications';
import searchRoutes from './routes/search';
import adminRoutes from './routes/admin';
import paymentRoutes from './routes/payments';
import dealRoutes from './routes/deals';
import destinationRoutes from './routes/destinations';

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

app.get('/api/health', (_req, res) => {
    res.json({ success: true, message: 'Quang Ninh Travel API v1.0.0', timestamp: new Date().toISOString() });
});

app.use('/api/auth', authRoutes);
app.use('/api/hotels', hotelRoutes);
app.use('/api/cruises', cruiseRoutes);
app.use('/api/tours', tourRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/transport', transportRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/reviews', reviewRoutes);
app.use('/api/favorites', favoriteRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/search', searchRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/deals', dealRoutes);
app.use('/api/destinations', destinationRoutes);

app.use((_req, res) => { res.status(404).json({ success: false, error: 'Not found' }); });

export const api = functions.https.onRequest(app);
