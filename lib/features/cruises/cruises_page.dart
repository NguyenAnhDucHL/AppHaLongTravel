import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class CruisesPage extends StatelessWidget {
  const CruisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cruises_title'.tr),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: 8,
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
                    height: 200,
                    color: AppColors.accentOrange.withOpacity(0.2),
                    child: const Center(
                      child: Icon(Icons.directions_boat, size: 64, color: AppColors.accentOrange),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingS,
                          vertical: AppTheme.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? AppColors.accentGold.withOpacity(0.2) : AppColors.primaryLight.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        ),
                        child: Text(
                          index % 2 == 0 ? 'cruise_luxury'.tr : 'cruise_standard'.tr,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: index % 2 == 0 ? AppColors.accentGold : AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        '${'cruise_name'.tr} ${index + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            index % 3 == 0 ? 'cruise_2d1n'.tr : 'cruise_1d'.tr,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Row(
                        children: [
                          ...List.generate(5, (i) => const Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.accentGold,
                          )),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            '(4.9)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          Text(
                            '\$${(index + 1) * 120}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.accentOrange,
                              fontWeight: FontWeight.bold,
                            ),
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
