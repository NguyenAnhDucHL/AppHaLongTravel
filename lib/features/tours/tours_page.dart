import 'package:flutter/material.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class ToursPage extends StatelessWidget {
  const ToursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Packages'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusL),
                  ),
                  child: Container(
                    height: 180,
                    color: AppColors.primaryLight.withOpacity(0.3),
                    child: const Center(
                      child: Icon(Icons.tour, size: 64, color: AppColors.primaryLight),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: AppTheme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppTheme.radiusS),
                            ),
                            child: Text(
                              'Best Seller',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Ha Long Bay Adventure ${index + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            '${index % 3 + 1} Days',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          const Icon(Icons.people, size: 16, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            'Max ${(index + 1) * 5} people',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      const Divider(),
                      Row(
                        children: [
                          Text(
                            'From ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '\$${(index + 1) * 100}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' /person',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingL,
                                vertical: AppTheme.spacingS,
                              ),
                            ),
                            child: const Text('Book Now'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
