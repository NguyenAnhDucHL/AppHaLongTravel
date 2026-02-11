import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('restaurants_title'.tr),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              children: [
                _buildChip(context, 'cuisine_all'.tr, true),
                _buildChip(context, 'cuisine_vietnamese'.tr, false),
                _buildChip(context, 'cuisine_seafood'.tr, false),
                _buildChip(context, 'cuisine_chinese'.tr, false),
                _buildChip(context, 'cuisine_western'.tr, false),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(AppTheme.radiusL),
                        ),
                        child: Container(
                          width: 120,
                          height: 120,
                          color: AppColors.accentGold.withOpacity(0.2),
                          child: const Icon(Icons.restaurant, size: 48, color: AppColors.accentGold),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${'restaurant'.tr} ${index + 1}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                'vietnamese_cuisine'.tr,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: AppTheme.spacingS),
                              Row(
                                children: [
                                  ...List.generate(5, (i) => const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: AppColors.accentGold,
                                  )),
                                  const SizedBox(width: AppTheme.spacingS),
                                  Text(
                                    '4.${index % 10}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacingXS),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(index + 1) * 0.5} ${'km_away'.tr}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: AppTheme.spacingS),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: AppColors.accentGold.withOpacity(0.2),
        labelStyle: TextStyle(
          color: selected ? AppColors.accentGold : AppColors.textMedium,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
