import 'package:flutter/material.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cuisines = ['All', 'Vietnamese', 'Seafood', 'Chinese', 'Western'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              itemCount: cuisines.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: ChoiceChip(
                    label: Text(cuisines[index]),
                    selected: index == 0,
                    selectedColor: AppColors.accentGold.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: index == 0 ? AppColors.accentGold : AppColors.textMedium,
                      fontWeight: index == 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
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
                                'Restaurant ${index + 1}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                'Vietnamese Cuisine',
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
                                    '${(index + 1) * 0.5} km away',
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
}
