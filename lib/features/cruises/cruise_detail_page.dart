import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/services/cruise_service.dart';
import 'package:quang_ninh_travel/core/services/booking_service.dart';
import 'package:quang_ninh_travel/core/services/favorite_service.dart';
import 'package:quang_ninh_travel/shared/widgets/location_viewer.dart';
import 'package:quang_ninh_travel/shared/widgets/contact_bottom_sheet.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';

class CruiseDetailPage extends StatefulWidget {
  const CruiseDetailPage({super.key});

  @override
  State<CruiseDetailPage> createState() => _CruiseDetailPageState();
}

class _CruiseDetailPageState extends State<CruiseDetailPage> {
  final _cruiseService = Get.find<CruiseService>();
  final _bookingService = Get.find<BookingService>();
  final _favoriteService = Get.find<FavoriteService>();

  late String _cruiseId;
  Map<String, dynamic>? _cruise;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _cruiseId = Get.arguments as String? ?? '';
    if (_cruiseId.isNotEmpty) {
      _fetchCruiseDetails();
    } else {
      Get.back();
    }
  }

  Future<void> _fetchCruiseDetails() async {
    try {
      final data = await _cruiseService.getCruise(_cruiseId);
      if (mounted) {
        setState(() {
          _cruise = data;
          _isLoading = false;
          _isFavorite = _favoriteService.isFavorite(_cruiseId);
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final success = await _favoriteService.toggleFavorite(_cruiseId, 'cruise');
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

    if (_cruise == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Cruise not found')),
      );
    }

    final cruise = _cruise!;
    final images = cruise['images'] as List?;
    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                cruise['name'] ?? 'Cruise Details',
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
                          child: const Icon(Icons.directions_boat, size: 80, color: Colors.white54),
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
                      Text('${cruise['rating'] ?? 0} (${cruise['reviewCount'] ?? 0} ${'reviews'.tr})',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text(
                        '\$${cruise['pricePerPerson'] ?? 0}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text('per_pax'.tr, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    children: [
                       const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                       const SizedBox(width: 4),
                       Expanded(child: Text(cruise['route'] ?? 'Ha Long Bay', style: Theme.of(context).textTheme.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Highlights
                  Text('highlights'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                   Wrap(
                    spacing: AppTheme.spacingS,
                    runSpacing: AppTheme.spacingS,
                    children: [
                      if (cruise['highlights'] != null)
                        ...(cruise['highlights'] as List).map((e) => Chip(
                          label: Text(e.toString()),
                          backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                          labelStyle: const TextStyle(color: AppColors.primaryBlue),
                        )),
                    ],
                  ),
                   const SizedBox(height: AppTheme.spacingL),

                  // Description
                  Text('description'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    cruise['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                   // Itinerary
                  Text('itinerary'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  if (cruise['itinerary'] != null)
                    ...(cruise['itinerary'] as List).map((e) => _buildItineraryItem(context, e)),
                   const SizedBox(height: AppTheme.spacingL),
                  
                  // Location Map
                  if (cruise['lat'] != null && cruise['lng'] != null) ...[
                    Text('location'.tr, 
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppTheme.spacingM),
                    LocationViewer(
                      lat: (cruise['lat'] as num).toDouble(),
                      lng: (cruise['lng'] as num).toDouble(),
                      address: cruise['route'],
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
                     arguments: {'item': cruise, 'type': 'cruise'},
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
                   final contact = cruise['contactInfo'] as Map<String, dynamic>?;
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

  Widget _buildItineraryItem(BuildContext context, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            child: Text(item['time'] ?? '', textAlign: TextAlign.center, style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(item['description'] ?? item['desc'] ?? '', style: Theme.of(context).textTheme.bodyMedium)),
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
