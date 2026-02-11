import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  // Mock favorites data
  static final List<Map<String, dynamic>> _favorites = [
    {
      'title': 'Paradise Hotel Quang Ninh',
      'type': 'Hotel',
      'icon': Icons.hotel,
      'rating': 4.8,
      'price': '\$120/night',
      'location': 'Quang Ninh City',
    },
    {
      'title': 'Quang Ninh Bay Cruise Deluxe',
      'type': 'Cruise',
      'icon': Icons.directions_boat,
      'rating': 4.9,
      'price': '\$240',
      'location': 'Quang Ninh Bay',
    },
    {
      'title': 'Seafood Palace',
      'type': 'Restaurant',
      'icon': Icons.restaurant,
      'rating': 4.5,
      'price': '\$\$',
      'location': 'Bai Chay',
    },
    {
      'title': 'Quang Ninh Full Day Tour',
      'type': 'Tour',
      'icon': Icons.tour,
      'rating': 4.7,
      'price': '\$100/person',
      'location': 'Quang Ninh Bay',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'.tr),
      ),
      body: _favorites.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final item = _favorites[index];
                return _buildFavoriteCard(context, item);
              },
            ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: AppColors.primaryBlue,
                size: 36,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['type'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      const Icon(Icons.star, size: 14, color: AppColors.accentGold),
                      const SizedBox(width: 2),
                      Text(
                        '${item['rating']}',
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
                        item['location'] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite, color: AppColors.error),
                ),
                Text(
                  item['price'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'no_favorites'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'no_favorites_sub'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
