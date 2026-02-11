import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock booking data
  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      'id': 'QN-2026-001',
      'title': 'Paradise Hotel',
      'type': 'Hotel',
      'icon': Icons.hotel,
      'date': '15 Mar 2026',
      'guests': 2,
      'price': 160,
      'status': 'Confirmed',
    },
    {
      'id': 'QN-2026-002',
      'title': 'Quang Ninh Bay Cruise',
      'type': 'Cruise',
      'icon': Icons.directions_boat,
      'date': '20 Mar 2026',
      'guests': 4,
      'price': 480,
      'status': 'Pending',
    },
  ];

  final List<Map<String, dynamic>> _completedBookings = [
    {
      'id': 'QN-2025-098',
      'title': 'Seafood Restaurant',
      'type': 'Restaurant',
      'icon': Icons.restaurant,
      'date': '10 Jan 2026',
      'guests': 3,
      'price': 75,
      'status': 'Completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_bookings'.tr),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primaryBlue,
          tabs: [
            Tab(text: 'upcoming'.tr),
            Tab(text: 'completed'.tr),
            Tab(text: 'cancelled'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(_upcomingBookings),
          _buildBookingList(_completedBookings),
          _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Map<String, dynamic>> bookings) {
    if (bookings.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: Icon(
                        booking['icon'] as IconData,
                        color: AppColors.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['title'] as String,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            booking['type'] as String,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(booking['status'] as String),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingM),
                const Divider(),
                const SizedBox(height: AppTheme.spacingS),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: AppColors.textLight),
                    const SizedBox(width: 6),
                    Text(
                      booking['date'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    const Icon(Icons.people, size: 14, color: AppColors.textLight),
                    const SizedBox(width: 6),
                    Text(
                      '${booking['guests']} ${'guests'.tr}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      '\$${booking['price']}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingM),
                Row(
                  children: [
                    Text(
                      '${'booking_id'.tr}: ${booking['id']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryBlue),
                      ),
                      child: Text('view_details'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Confirmed':
        color = AppColors.success;
        break;
      case 'Pending':
        color = AppColors.warning;
        break;
      case 'Cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'no_bookings'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'no_bookings_sub'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
