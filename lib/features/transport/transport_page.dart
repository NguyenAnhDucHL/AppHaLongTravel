import 'package:flutter/material.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class TransportPage extends StatelessWidget {
  const TransportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'Airport Transfer', 'icon': Icons.local_airport, 'price': 30},
      {'title': 'Private Car', 'icon': Icons.directions_car, 'price': 50},
      {'title': 'Car with Driver', 'icon': Icons.car_rental, 'price': 80},
      {'title': 'Bus Rental', 'icon': Icons.directions_bus, 'price': 150},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport Services'),
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
                'Available 24/7',
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
                    'per trip',
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
