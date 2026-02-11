import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('admin_dashboard'.tr),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Grid
            _buildStatsGrid(context),
            const SizedBox(height: AppTheme.spacingL),

            // Management Sections
            Text(
              'admin'.tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            _buildManagementGrid(context),
            const SizedBox(height: AppTheme.spacingL),

            // Recent Bookings
            Text(
              'recent_bookings'.tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            _buildRecentBookingsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final stats = [
      {'label': 'total_bookings'.tr, 'value': '1,284', 'icon': Icons.calendar_today, 'color': AppColors.primaryBlue},
      {'label': 'total_revenue'.tr, 'value': '\$89.5K', 'icon': Icons.attach_money, 'color': AppColors.success},
      {'label': 'total_users'.tr, 'value': '3,421', 'icon': Icons.people, 'color': AppColors.accentOrange},
      {'label': 'active_tours'.tr, 'value': '42', 'icon': Icons.tour, 'color': AppColors.accentCoral},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      stat['label'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 20,
                  ),
                ],
              ),
              Text(
                stat['value'] as String,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: stat['color'] as Color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildManagementGrid(BuildContext context) {
    final items = [
      {'label': 'manage_hotels'.tr, 'icon': Icons.hotel, 'color': AppColors.primaryBlue},
      {'label': 'manage_tours'.tr, 'icon': Icons.tour, 'color': AppColors.accentOrange},
      {'label': 'manage_restaurants'.tr, 'icon': Icons.restaurant, 'color': AppColors.accentGold},
      {'label': 'manage_users'.tr, 'icon': Icons.people, 'color': AppColors.accentCoral},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
        childAspectRatio: 1.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: (item['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 28,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    item['label'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentBookingsList(BuildContext context) {
    final recentBookings = [
      {'user': 'Nguyễn Văn A', 'service': 'Paradise Hotel', 'amount': '\$160', 'date': 'Today'},
      {'user': '张三', 'service': 'Bay Cruise Deluxe', 'amount': '\$480', 'date': 'Yesterday'},
      {'user': 'Trần Thị B', 'service': 'Airport Transfer', 'amount': '\$30', 'date': '2 days ago'},
      {'user': '李四', 'service': 'Seafood Restaurant', 'amount': '\$75', 'date': '3 days ago'},
    ];

    return Column(
      children: recentBookings.map((booking) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: Text(
                (booking['user'] as String).substring(0, 1),
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              booking['user'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              booking['service'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  booking['amount'] as String,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  booking['date'] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
