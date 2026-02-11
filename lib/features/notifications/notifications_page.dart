import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static final _notifications = [
    {'title': 'notif_booking_confirmed', 'body': 'notif_booking_body', 'time': '2m', 'icon': Icons.check_circle, 'color': AppColors.success, 'read': false},
    {'title': 'notif_special_offer', 'body': 'notif_offer_body', 'time': '1h', 'icon': Icons.local_offer, 'color': AppColors.accentOrange, 'read': false},
    {'title': 'notif_review_request', 'body': 'notif_review_body', 'time': '3h', 'icon': Icons.star, 'color': AppColors.accentGold, 'read': true},
    {'title': 'notif_payment_success', 'body': 'notif_payment_body', 'time': '1d', 'icon': Icons.payment, 'color': AppColors.primaryBlue, 'read': true},
    {'title': 'notif_welcome', 'body': 'notif_welcome_body', 'time': '2d', 'icon': Icons.waving_hand, 'color': AppColors.accentCoral, 'read': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
        actions: [
          TextButton(onPressed: () {}, child: Text('mark_all_read'.tr)),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textLight),
                  const SizedBox(height: AppTheme.spacingM),
                  Text('no_notifications'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textLight)),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final n = _notifications[index];
                final isRead = n['read'] as bool;
                return Container(
                  color: isRead ? null : AppColors.primaryBlue.withOpacity(0.04),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppTheme.spacingM),
                    leading: CircleAvatar(
                      backgroundColor: (n['color'] as Color).withOpacity(0.15),
                      child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20),
                    ),
                    title: Text(
                      (n['title'] as String).tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text((n['body'] as String).tr, style: Theme.of(context).textTheme.bodySmall, maxLines: 2),
                        const SizedBox(height: 4),
                        Text('${n['time']} ${'ago'.tr}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                      ],
                    ),
                    trailing: !isRead ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle)) : null,
                    onTap: () {},
                  ),
                );
              },
            ),
    );
  }
}
