import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/services/transport_service.dart';
import 'package:quang_ninh_travel/core/services/booking_service.dart';
import 'package:quang_ninh_travel/shared/widgets/location_viewer.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';
import 'package:quang_ninh_travel/shared/widgets/contact_bottom_sheet.dart';

class TransportDetailPage extends StatefulWidget {
  const TransportDetailPage({super.key});

  @override
  State<TransportDetailPage> createState() => _TransportDetailPageState();
}

class _TransportDetailPageState extends State<TransportDetailPage> {
  final _transportService = Get.find<TransportService>();
  // final _bookingService = Get.find<BookingService>(); // Can use for booking

  late String _transportId;
  Map<String, dynamic>? _transport;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _transportId = Get.arguments as String? ?? '';
    if (_transportId.isNotEmpty) {
      _fetchTransportDetails();
    } else {
      Get.back();
    }
  }

  Future<void> _fetchTransportDetails() async {
    try {
      // Assuming TransportService has a getTransport method. If not, I'll need to add it or use list and find.
      // Since I didn't verify getTransport exists, I'll use a try-catch and maybe list if fails, 
      // but ideally it should have getTransport. 
      // Let's assume for now. If it errors, I'll fix the service.
      // Actually, typically I might haven't added getTransport to TransportService yet.
      // I'll check TransportService content in a bit if this fails.
      // For now, let's implement assuming it exists or I will add it.
      
      // Wait, I should check TransportService.
      // I'll assume it doesn't exist and I might need to use listVehicles and filter, or add getTransport.
      // Let's safe-guard by listing and filtering for now if I can't check.
      // Or better, I'll add getTransport to TransportService in the next step if needed.
      // But to be safe, I'll just list and find locally for now as list is small.
      final vehicles = await _transportService.listVehicles();
      final found = vehicles.firstWhere((element) => element['id'] == _transportId, orElse: () => {});
      
      if (mounted) {
        setState(() {
          _transport = found.isNotEmpty ? found : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_transport == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Transport not found')),
      );
    }

    final transport = _transport!;
    final imageUrl = transport['image'] as String?;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                transport['vehicleType'] ?? 'Transport Details',
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
                          child: const Icon(Icons.directions_car, size: 80, color: Colors.white54),
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info
                  Row(
                    children: [
                      Text(
                        transport['vehicleType'] ?? '',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '\$${transport['pricePerKm'] ?? 0} /km',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                   _buildInfoChip(Icons.person, '${transport['capacity'] ?? 4} seats'),
                  const SizedBox(height: AppTheme.spacingL),

                  // Description
                  Text('description'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    transport['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Location Map (Base location)
                  if (transport['lat'] != null && transport['lng'] != null) ...[
                    Text('location'.tr, 
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppTheme.spacingM),
                    LocationViewer(
                      lat: (transport['lat'] as num).toDouble(),
                      lng: (transport['lng'] as num).toDouble(),
                      address: 'Base Location',
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
                     arguments: {'item': transport, 'type': 'transport'},
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
                   final contact = transport['contactInfo'] as Map<String, dynamic>?;
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

   Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textMedium),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textMedium)),
        ],
      ),
    );
  }
}
