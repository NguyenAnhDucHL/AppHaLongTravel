import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

import 'package:quang_ninh_travel/core/services/tour_service.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({super.key});

  @override
  State<ToursPage> createState() => _ToursPageState();
}

class _ToursPageState extends State<ToursPage> {
  final _tourService = Get.find<TourService>();
  List<Map<String, dynamic>> _tours = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTours();
  }

  Future<void> _fetchTours() async {
    try {
      final data = await _tourService.listTours();
      if (mounted) {
        setState(() {
          _tours = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching tours: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tours_title'.tr),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tours.isEmpty
              ? Center(child: Text('no_data'.tr))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  itemCount: _tours.length,
                  itemBuilder: (context, index) {
                    final tour = _tours[index];
                    final images = tour['images'] as List?;
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
                              height: 180,
                              color: AppColors.primaryLight.withOpacity(0.3),
                              child: imageUrl != null
                                  ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity)
                                  : const Center(
                                      child: Icon(Icons.tour, size: 64, color: AppColors.primaryLight),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.spacingS,
                                        vertical: AppTheme.spacingXS,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                                      ),
                                      child: Text(
                                        tour['difficulty'] == 0 ? 'Dễ' : (tour['difficulty'] == 1 ? 'Vừa' : 'Khó'),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  tour['name'] ?? 'Unnamed Tour',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 16, color: AppColors.textLight),
                                    const SizedBox(width: 4),
                                    Text(
                                      tour['duration'] ?? '1 day',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(width: AppTheme.spacingM),
                                    const Icon(Icons.people, size: 16, color: AppColors.textLight),
                                    const SizedBox(width: 4),
                                    Text(
                                      'max_people'.trParams({'count': '${tour['groupSize'] ?? 0}'}),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                const Divider(),
                                Row(
                                  children: [
                                    Text(
                                      '${'from'.tr} ',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      '\$${tour['price'] ?? 0}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' ${'per_person'.tr}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppTheme.spacingL,
                                          vertical: AppTheme.spacingS,
                                        ),
                                      ),
                                      child: Text('book_now'.tr),
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
