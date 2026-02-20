import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

import 'package:quang_ninh_travel/core/services/restaurant_service.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final _restaurantService = Get.find<RestaurantService>();
  List<Map<String, dynamic>> _restaurants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    try {
      final data = await _restaurantService.listRestaurants();
      if (mounted) {
        setState(() {
          _restaurants = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _restaurants.isEmpty
                    ? Center(child: Text('no_data'.tr))
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        itemCount: _restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = _restaurants[index];
                          final images = restaurant['images'] as List?;
                          final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

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
                                    child: imageUrl != null
                                        ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                                        : const Icon(Icons.restaurant, size: 48, color: AppColors.accentGold),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppTheme.spacingM),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant['name'] ?? 'Unnamed Restaurant',
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: AppTheme.spacingXS),
                                        Text(
                                          restaurant['cuisine'] ?? 'Cuisine',
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
                                              '(${restaurant['rating'] ?? 5.0})',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppTheme.spacingXS),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                restaurant['address'] ?? 'No address',
                                                style: Theme.of(context).textTheme.bodySmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
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
