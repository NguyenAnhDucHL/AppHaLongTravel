import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/services/restaurant_service.dart';
import 'package:quang_ninh_travel/core/services/favorite_service.dart';
import 'package:quang_ninh_travel/shared/widgets/location_viewer.dart';
import 'package:quang_ninh_travel/shared/widgets/contact_bottom_sheet.dart';
// import 'package:quang_ninh_travel/app/routes/app_pages.dart'; // No booking for restaurant yet, maybe reservation later

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({super.key});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final _restaurantService = Get.find<RestaurantService>();
  final _favoriteService = Get.find<FavoriteService>();

  late String _restaurantId;
  Map<String, dynamic>? _restaurant;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _restaurantId = Get.arguments as String? ?? '';
    if (_restaurantId.isNotEmpty) {
      _fetchRestaurantDetails();
    } else {
      Get.back();
    }
  }

  Future<void> _fetchRestaurantDetails() async {
    try {
      final data = await _restaurantService.getRestaurant(_restaurantId);
       if (mounted) {
        setState(() {
          _restaurant = data;
          _isLoading = false;
          _isFavorite = _favoriteService.isFavorite(_restaurantId);
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final success = await _favoriteService.toggleFavorite(_restaurantId, 'restaurant');
    if (success && mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_restaurant == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Restaurant not found')),
      );
    }

    final restaurant = _restaurant!;
    final images = restaurant['images'] as List?;
    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurant['name'] ?? 'Restaurant Details',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                   imageUrl != null
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.primaryLight.withOpacity(0.3),
                          child: const Icon(Icons.restaurant, size: 80, color: Colors.white54),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AppColors.overlayGradient,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
               IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? AppColors.error : Colors.white),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Rating & Price
                  Row(
                    children: [
                      ...List.generate(5, (_) => const Icon(Icons.star, size: 18, color: AppColors.accentGold)),
                      const SizedBox(width: 8),
                      Text('${restaurant['rating'] ?? 0} (${restaurant['reviewCount'] ?? 0} ${'reviews'.tr})',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text(
                        restaurant['priceRange'] ?? '\$\$', // e.g. $$
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                   const SizedBox(height: AppTheme.spacingS),

                  // Cuisine & Address
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          (restaurant['cuisine'] as List?)?.join(', ') ?? 'Local Cuisine',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                       Expanded(
                        child: Text(
                          restaurant['address'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                   // Opening Hours
                   if (restaurant['openingHours'] != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 20, color: AppColors.primaryBlue),
                          const SizedBox(width: 8),
                          Text(
                            'Open: ${restaurant['openingHours']}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                   ],

                   // Popular Dishes
                   if (restaurant['popularDishes'] != null) ...[
                      Text('popular_dishes'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppTheme.spacingM),
                      Wrap(
                        spacing: AppTheme.spacingS,
                        runSpacing: AppTheme.spacingS,
                        children: (restaurant['popularDishes'] as List).map((e) => Chip(
                          label: Text(e.toString()),
                          backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                          labelStyle: const TextStyle(color: AppColors.primaryBlue),
                        )).toList(),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                   ],

                  // Description
                  Text('description'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingS),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildDishCard(context, 'dish_spring_rolls'.tr, '\$8'),
                        _buildDishCard(context, 'dish_pho'.tr, '\$6'),
                        _buildDishCard(context, 'dish_seafood_hotpot'.tr, '\$25'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Menu Categories
                  Text('menu'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildMenuItem(context, 'dish_grilled_squid'.tr, 'menu_desc_squid'.tr, '\$12'),
                  _buildMenuItem(context, 'dish_spring_rolls'.tr, 'menu_desc_rolls'.tr, '\$8'),
                  _buildMenuItem(context, 'dish_pho'.tr, 'menu_desc_pho'.tr, '\$6'),
                  _buildMenuItem(context, 'dish_seafood_hotpot'.tr, 'menu_desc_hotpot'.tr, '\$25'),
                  _buildMenuItem(context, 'dish_grilled_fish'.tr, 'menu_desc_fish'.tr, '\$15'),
                  _buildMenuItem(context, 'dish_banh_cuon'.tr, 'menu_desc_banh'.tr, '\$5'),
                  const SizedBox(height: AppTheme.spacingL),

                  // Contact Info
                  Text('contact'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildContactRow(context, Icons.phone, '+84 333 456 789'),
                  _buildContactRow(context, Icons.location_on, 'restaurant_address'.tr),
                  _buildContactRow(context, Icons.schedule, 'restaurant_hours'.tr),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
                final contact = restaurant['contactInfo'] as Map<String, dynamic>?;
                Get.bottomSheet(
                  ContactBottomSheet(
                    phoneNumber: contact?['phone'],
                    email: contact?['email'],
                    website: contact?['website'],
                  ),
                );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: Text('contact'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(AppTheme.radiusS)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDishCard(BuildContext context, String name, String price) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: AppTheme.spacingM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusM)),
            ),
            child: const Center(child: Icon(Icons.restaurant_menu, size: 36, color: AppColors.accentGold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(price, style: TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String name, String desc, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight), maxLines: 2),
              ],
            ),
          ),
          Text(price, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.accentOrange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBlue),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
