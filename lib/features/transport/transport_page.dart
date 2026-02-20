import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

import 'package:quang_ninh_travel/core/services/transport_service.dart';

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  final _transportService = Get.find<TransportService>();
  List<Map<String, dynamic>> _transports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransports();
  }

  Future<void> _fetchTransports() async {
    try {
      final data = await _transportService.listVehicles();
      if (mounted) {
        setState(() {
          _transports = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching transports: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('transport_title'.tr),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transports.isEmpty
              ? Center(child: Text('no_data'.tr))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  itemCount: _transports.length,
                  itemBuilder: (context, index) {
                    final transport = _transports[index];
                    final images = transport['images'] as List?;
                    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

                    return Card(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppTheme.spacingM),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: AppColors.accentCoral.withOpacity(0.1),
                            child: imageUrl != null
                                ? Image.network(imageUrl, fit: BoxFit.cover)
                                : const Icon(
                                    Icons.directions_bus,
                                    size: 32,
                                    color: AppColors.accentCoral,
                                  ),
                          ),
                        ),
                        title: Text(
                          transport['name'] ?? 'Unnamed Transport',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transport['type'] ?? 'Standard',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Capacity: ${transport['capacity'] ?? 4} seats',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${transport['price'] ?? 0}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'per_trip'.tr,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
