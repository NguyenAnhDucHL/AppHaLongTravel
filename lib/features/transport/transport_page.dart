import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class TransportPage extends StatelessWidget {
  const TransportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'transport_airport'.tr, 'icon': Icons.local_airport, 'price': 30},
      {'title': 'transport_private_car'.tr, 'icon': Icons.directions_car, 'price': 50},
      {'title': 'transport_car_driver'.tr, 'icon': Icons.car_rental, 'price': 80},
      {'title': 'transport_bus'.tr, 'icon': Icons.directions_bus, 'price': 150},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('transport_title'.tr),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
            child: ListTile(
              contentPadding: const EdgeInsets.all(AppTheme.spacingM),
              leading: Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.accentCoral.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  service['icon'] as IconData,
                  size: 32,
                  color: AppColors.accentCoral,
                ),
              ),
              title: Text(
                service['title'] as String,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                'available_24_7'.tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${service['price']}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'per_trip'.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
