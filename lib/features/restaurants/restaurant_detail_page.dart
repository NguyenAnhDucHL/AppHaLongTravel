import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${'restaurant'.tr} Phố Biển', style: const TextStyle(fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.accentGold.withOpacity(0.2),
                    child: const Icon(Icons.restaurant, size: 80, color: Colors.white54),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.overlayGradient),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      _buildTag(context, 'cuisine_seafood'.tr, AppColors.accentGold),
                      const SizedBox(width: 8),
                      _buildTag(context, 'cuisine_vietnamese'.tr, AppColors.success),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (_) => const Icon(Icons.star, size: 18, color: AppColors.accentGold)),
                      const SizedBox(width: 8),
                      Text('4.7 (198 ${'reviews'.tr})', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Info Row
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.location_on, '1.2 ${'km_away'.tr}'),
                      const SizedBox(width: AppTheme.spacingM),
                      _buildInfoChip(context, Icons.schedule, '10:00 - 22:00'),
                      const SizedBox(width: AppTheme.spacingM),
                      _buildInfoChip(context, Icons.attach_money, '\$\$'),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Description
                  Text('about_restaurant'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'restaurant_desc'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMedium, height: 1.6),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Popular Dishes
                  Text('popular_dishes'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDishCard(context, 'dish_grilled_squid'.tr, '\$12'),
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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: Text('call'.tr),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today),
                label: Text('reserve_table'.tr),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
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
