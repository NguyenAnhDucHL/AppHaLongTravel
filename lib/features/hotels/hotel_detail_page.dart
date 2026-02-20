import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/services/hotel_service.dart';
import 'package:quang_ninh_travel/core/services/booking_service.dart';
import 'package:quang_ninh_travel/core/services/favorite_service.dart';
import 'package:quang_ninh_travel/shared/widgets/contact_bottom_sheet.dart';
import 'package:quang_ninh_travel/shared/widgets/location_viewer.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart'; // Ensure Routes is imported

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({super.key});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  final _hotelService = Get.find<HotelService>();
  final _bookingService = Get.find<BookingService>();
  final _favoriteService = Get.find<FavoriteService>();

  late String _hotelId;
  Map<String, dynamic>? _hotel;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _hotelId = Get.arguments as String? ?? '';
    if (_hotelId.isNotEmpty) {
      _fetchHotelDetails();
    } else {
      Get.back(); // Go back if no ID
    }
  }

  Future<void> _fetchHotelDetails() async {
    try {
      final data = await _hotelService.getHotel(_hotelId);
      if (mounted) {
        setState(() {
          _hotel = data;
          _isLoading = false;
          _isFavorite = _favoriteService.isFavorite(_hotelId);
        });
      }
    } catch (e) {
      print('Error fetching hotel details: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final success = await _favoriteService.toggleFavorite(_hotelId, 'hotel');
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

    if (_hotel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Hotel not found')),
      );
    }

    final hotel = _hotel!;
    final images = hotel['images'] as List?;
    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                hotel['name'] ?? 'Hotel Details',
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
                          child: const Icon(Icons.hotel, size: 80, color: Colors.white54),
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
                      Text('${hotel['rating'] ?? 0} (${hotel['reviewCount'] ?? 0} ${'reviews'.tr})',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text(
                        '\$${hotel['pricePerNight'] ?? 0}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text('per_night'.tr, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel['address'] ?? 'No address',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Amenities
                  Text('amenities'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingM),
                  Wrap(
                    spacing: AppTheme.spacingM,
                    runSpacing: AppTheme.spacingM,
                    children: [
                      if (hotel['amenities'] != null)
                        ...(hotel['amenities'] as List).map((e) => _buildAmenity(context, Icons.check_circle, e.toString())),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Description
                  Text('description'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    hotel['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Location Map
                  if (hotel['lat'] != null && hotel['lng'] != null) ...[
                    Text('location'.tr, // Ensure key exists or use 'Location'
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppTheme.spacingM),
                    LocationViewer(
                      lat: (hotel['lat'] as num).toDouble(),
                      lng: (hotel['lng'] as num).toDouble(),
                      address: hotel['address'],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],

                  // Reviews (Placeholder for now, could be fetched)
                  Row(
                    children: [
                      Text('reviews'.tr,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: Text('view_all'.tr)),
                    ],
                  ),
                  // ...List.generate(2, (i) => _buildReviewCard(context, i)),
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
                     arguments: {'item': hotel, 'type': 'hotel'},
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
                   final contact = hotel['contactInfo'] as Map<String, dynamic>?;
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

  Widget _buildAmenity(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

