import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class CruiseDetailPage extends StatelessWidget {
  const CruiseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${'cruise_name'.tr} Premium', style: const TextStyle(fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.accentOrange.withOpacity(0.2),
                    child: const Icon(Icons.directions_boat, size: 80, color: Colors.white54),
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
                      _buildTag(context, 'cruise_luxury'.tr, AppColors.accentGold),
                      const SizedBox(width: 8),
                      _buildTag(context, 'cruise_2d1n'.tr, AppColors.primaryBlue),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Rating & Price
                  Row(
                    children: [
                      ...List.generate(5, (_) => const Icon(Icons.star, size: 18, color: AppColors.accentGold)),
                      const SizedBox(width: 8),
                      Text('4.9 (512 ${'reviews'.tr})', style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text('\$250', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accentOrange, fontWeight: FontWeight.bold)),
                      Text('/${'person'.tr}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Highlights
                  Text('highlights'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildHighlight(context, Icons.landscape, 'highlight_bay'.tr),
                  _buildHighlight(context, Icons.restaurant, 'highlight_dining'.tr),
                  _buildHighlight(context, Icons.kayaking, 'highlight_kayaking'.tr),
                  _buildHighlight(context, Icons.dark_mode, 'highlight_sunset'.tr),
                  const SizedBox(height: AppTheme.spacingL),

                  // Itinerary
                  Text('itinerary'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildItineraryItem(context, '08:00', 'itinerary_pickup'.tr),
                  _buildItineraryItem(context, '10:00', 'itinerary_board'.tr),
                  _buildItineraryItem(context, '12:00', 'itinerary_lunch'.tr),
                  _buildItineraryItem(context, '14:00', 'itinerary_explore'.tr),
                  _buildItineraryItem(context, '17:00', 'itinerary_sunset'.tr),
                  _buildItineraryItem(context, '19:00', 'itinerary_dinner'.tr),
                  const SizedBox(height: AppTheme.spacingL),

                  // Cabins
                  Text('cabin_types'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  ...List.generate(3, (i) => _buildCabinCard(context, i)),
                  const SizedBox(height: AppTheme.spacingL),

                  // Includes
                  Text('whats_included'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildInclude(context, Icons.check_circle, 'include_meals'.tr, true),
                  _buildInclude(context, Icons.check_circle, 'include_guide'.tr, true),
                  _buildInclude(context, Icons.check_circle, 'include_kayak'.tr, true),
                  _buildInclude(context, Icons.check_circle, 'include_insurance'.tr, true),
                  _buildInclude(context, Icons.cancel, 'exclude_drinks'.tr, false),
                  _buildInclude(context, Icons.cancel, 'exclude_tips'.tr, false),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('from'.tr, style: Theme.of(context).textTheme.bodySmall),
                Text('\$250 /${'person'.tr}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accentOrange, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: AppTheme.spacingL),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.accentOrange,
                  foregroundColor: Colors.white,
                ),
                child: Text('book_now'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildHighlight(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentOrange, size: 20),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildItineraryItem(BuildContext context, String time, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Text(time, textAlign: TextAlign.center, style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(desc, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildCabinCard(BuildContext context, int index) {
    final cabins = ['Standard Cabin', 'Deluxe Cabin', 'Suite Cabin'];
    final prices = [200, 350, 500];
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: const Icon(Icons.king_bed, color: AppColors.accentOrange),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cabins[index], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('2 ${'guests'.tr}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text('\$${prices[index]}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accentOrange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInclude(BuildContext context, IconData icon, String text, bool included) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: included ? AppColors.success : AppColors.error, size: 18),
          const SizedBox(width: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: included ? AppColors.textDark : AppColors.textLight,
          )),
        ],
      ),
    );
  }
}
