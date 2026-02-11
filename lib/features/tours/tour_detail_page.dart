import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class TourDetailPage extends StatelessWidget {
  const TourDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${'tour_name'.tr} Explorer', style: const TextStyle(fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.primaryLight.withOpacity(0.3),
                    child: const Icon(Icons.tour, size: 80, color: Colors.white54),
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
                      _buildTag(context, 'best_seller'.tr, AppColors.success),
                      const SizedBox(width: 8),
                      _buildTag(context, '3 ${'days'.tr}', AppColors.primaryBlue),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (_) => const Icon(Icons.star, size: 18, color: AppColors.accentGold)),
                      const SizedBox(width: 8),
                      Text('4.8 (289 ${'reviews'.tr})', style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text('\$200', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                      Text('/${'person'.tr}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Overview
                  Text('overview'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingS),
                  Text('tour_overview'.tr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMedium, height: 1.6)),
                  const SizedBox(height: AppTheme.spacingL),

                  // Tour Info Grid
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard(context, Icons.schedule, 'duration'.tr, '3 ${'days'.tr}')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard(context, Icons.people, 'group_size'.tr, 'max_people'.trParams({'count': '15'}))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard(context, Icons.language, 'guide_lang'.tr, 'EN/VI/ZH')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard(context, Icons.directions_bus, 'transport'.tr, 'transport_included'.tr)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Day-by-day Schedule
                  Text('schedule'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildDayCard(context, 1, 'day1_title'.tr, 'day1_desc'.tr),
                  _buildDayCard(context, 2, 'day2_title'.tr, 'day2_desc'.tr),
                  _buildDayCard(context, 3, 'day3_title'.tr, 'day3_desc'.tr),
                  const SizedBox(height: AppTheme.spacingL),

                  // Guide Info
                  Text('your_guide'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                          child: const Icon(Icons.person, color: AppColors.primaryBlue, size: 30),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nguyễn Minh', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              Text('guide_exp'.tr, style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ...List.generate(5, (_) => const Icon(Icons.star, size: 14, color: AppColors.accentGold)),
                                  const SizedBox(width: 4),
                                  Text('5.0', style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                Text('\$200 /${'person'.tr}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: AppTheme.spacingL),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
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
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(AppTheme.radiusS)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, int day, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(AppTheme.radiusS)),
                child: Text('Day $day', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMedium)),
        ],
      ),
    );
  }
}
