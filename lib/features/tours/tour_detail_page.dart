import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/shared/widgets/contact_bottom_sheet.dart';

import 'package:quang_ninh_travel/app/routes/app_pages.dart';
import 'package:quang_ninh_travel/shared/widgets/location_viewer.dart';

class TourDetailPage extends StatelessWidget {
  const TourDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = Get.arguments as Map<String, dynamic>;
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
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Difficulty & Duration
                  Row(
                    children: [
                      _buildInfoChip(Icons.timer, tour['duration'] ?? ''),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.speed, (tour['difficulty'] as String? ?? 'easy').toUpperCase()),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.group, '${tour['groupSize'] ?? 0} max'),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Description
                  Text('description'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    tour['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Schedule
                  Text('schedule'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                   if (tour['schedule'] != null)
                    ...(tour['schedule'] as List).map((e) => _buildScheduleItem(context, e)),
                   const SizedBox(height: AppTheme.spacingL),

                  // Tour Guide (if available)
                  if (tour['guide'] != null) ...[
                     Text('tour_guide'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                     const SizedBox(height: AppTheme.spacingM),
                     _buildGuideInfo(context, tour['guide']),
                     const SizedBox(height: AppTheme.spacingL),
                  ],

                  // Location Map
                  if (tour['lat'] != null && tour['lng'] != null) ...[
                    Text('location'.tr, 
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppTheme.spacingM),
                    LocationViewer(
                      lat: (tour['lat'] as num).toDouble(),
                      lng: (tour['lng'] as num).toDouble(),
                      address: 'Meeting Point',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],
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
              child: ElevatedButton(
                onPressed: () {
                    Get.toNamed(
                      Routes.bookingCreate,
                      arguments: {'item': tour, 'type': 'tour'},
                    );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: Text('book_now'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
             Expanded(
              child: OutlinedButton(
                onPressed: () {
                   final contact = tour['contactInfo'] as Map<String, dynamic>?;
                   Get.bottomSheet(
                     ContactBottomSheet(
                       phoneNumber: contact?['phone'],
                       email: contact?['email'],
                       website: contact?['website'],
                     ),
                   );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryBlue),
                ),
                child: Text('contact'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingS),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
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

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textMedium),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item['time'] ?? '08:00',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'] ?? '', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item['activity'] ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMedium)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideInfo(BuildContext context, Map<String, dynamic> guide) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(guide['avatar'] ?? 'https://i.pravatar.cc/150'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(guide['name'] ?? 'Guide Name', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('${'languages'.tr}: ${guide['languages'] ?? 'EN/VI'}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
