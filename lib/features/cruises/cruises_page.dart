import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

import 'package:quang_ninh_travel/core/services/cruise_service.dart';

class CruisesPage extends StatefulWidget {
  const CruisesPage({super.key});

  @override
  State<CruisesPage> createState() => _CruisesPageState();
}

class _CruisesPageState extends State<CruisesPage> {
  final _cruiseService = Get.find<CruiseService>();
  List<Map<String, dynamic>> _cruises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCruises();
  }

  Future<void> _fetchCruises() async {
    try {
      final data = await _cruiseService.listCruises();
      if (mounted) {
        setState(() {
          _cruises = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching cruises: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cruises.isEmpty
              ? Center(child: Text('no_data'.tr))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  itemCount: _cruises.length,
                  itemBuilder: (context, index) {
                    final cruise = _cruises[index];
                    final images = cruise['images'] as List?;
                    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

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
                              child: imageUrl != null
                                  ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity)
                                  : const Center(
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
                                    color: (cruise['type'] == 'Luxury' ? AppColors.accentGold : AppColors.primaryBlue).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                                  ),
                                  child: Text(
                                    cruise['type'] ?? 'Standard',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: cruise['type'] == 'Luxury' ? AppColors.accentGold : AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  cruise['name'] ?? 'Unnamed Cruise',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 16, color: AppColors.textLight),
                                    const SizedBox(width: 4),
                                    Text(
                                      cruise['duration'] ?? '2 days 1 night',
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
                                      '(${cruise['rating'] ?? 5.0})',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${cruise['price'] ?? 0}',
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
