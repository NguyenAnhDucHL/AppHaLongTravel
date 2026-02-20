import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';

import 'package:quang_ninh_travel/core/services/hotel_service.dart';

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  final _hotelService = Get.find<HotelService>();
  List<Map<String, dynamic>> _hotels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    try {
      final data = await _hotelService.listHotels();
      if (mounted) {
        setState(() {
          _hotels = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching hotels: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hotels_title'.tr),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hotels.isEmpty
              ? Center(child: Text('no_data'.tr))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  itemCount: _hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = _hotels[index];
                    final images = hotel['images'] as List?;
                    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

                    return Card(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.hotelDetail, arguments: hotel['id']);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180,
                              color: AppColors.primaryLight.withOpacity(0.3),
                              child: imageUrl != null
                                  ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity)
                                  : const Center(
                                      child: Icon(Icons.hotel, size: 64, color: AppColors.textLight),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppTheme.spacingM),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel['name'] ?? 'Unnamed Hotel',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: AppTheme.spacingS),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          hotel['address'] ?? 'No address',
                                          style: Theme.of(context).textTheme.bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                        '(${hotel['rating'] ?? 5.0})',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${_fmt(hotel['price'] ?? 0)} ${'per_night'.tr}',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.primaryBlue,
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
                      ),
                    );
                  },
                ),
    );
  }


  String _fmt(dynamic price) {
    if (price == null) return '\$0';
    return '\$$price';
  }
}
