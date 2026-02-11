import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class TransportBookingPage extends StatefulWidget {
  const TransportBookingPage({super.key});

  @override
  State<TransportBookingPage> createState() => _TransportBookingPageState();
}

class _TransportBookingPageState extends State<TransportBookingPage> {
  int _selectedType = 0;
  DateTime _pickupDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _pickupTime = const TimeOfDay(hour: 9, minute: 0);
  final _pickupController = TextEditingController(text: 'Van Don International Airport');
  final _dropoffController = TextEditingController(text: 'Bai Chay, Ha Long');
  int _passengers = 2;

  final _vehicleTypes = [
    {'name': 'transport_sedan', 'seats': '4', 'price': 35, 'icon': Icons.directions_car},
    {'name': 'transport_suv', 'seats': '7', 'price': 50, 'icon': Icons.directions_car_filled},
    {'name': 'transport_van', 'seats': '16', 'price': 80, 'icon': Icons.airport_shuttle},
    {'name': 'transport_limo', 'seats': '4', 'price': 120, 'icon': Icons.local_taxi},
  ];

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('transport_booking'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pickup / Dropoff
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.circle, size: 12, color: AppColors.success),
                          Container(width: 2, height: 30, color: AppColors.divider),
                          const Icon(Icons.location_on, size: 16, color: AppColors.error),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: _pickupController,
                              decoration: InputDecoration(
                                labelText: 'pickup_location'.tr,
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                            const Divider(),
                            TextField(
                              controller: _dropoffController,
                              decoration: InputDecoration(
                                labelText: 'dropoff_location'.tr,
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_vert, color: AppColors.primaryBlue),
                        onPressed: () {
                          setState(() {
                            final temp = _pickupController.text;
                            _pickupController.text = _dropoffController.text;
                            _dropoffController.text = temp;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Date & Time
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context, initialDate: _pickupDate,
                        firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (d != null) setState(() => _pickupDate = d);
                    },
                    child: _buildInfoBox(context, Icons.calendar_today, 'pickup_date'.tr,
                      '${_pickupDate.day}/${_pickupDate.month}/${_pickupDate.year}'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final t = await showTimePicker(context: context, initialTime: _pickupTime);
                      if (t != null) setState(() => _pickupTime = t);
                    },
                    child: _buildInfoBox(context, Icons.access_time, 'pickup_time'.tr,
                      _pickupTime.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Passengers
            _buildInfoBox(context, Icons.people, 'passengers'.tr, '$_passengers',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryBlue),
                    onPressed: _passengers > 1 ? () => setState(() => _passengers--) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryBlue),
                    onPressed: _passengers < 16 ? () => setState(() => _passengers++) : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Vehicle Types
            Text('select_vehicle'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            ...List.generate(_vehicleTypes.length, (i) {
              final v = _vehicleTypes[i];
              final isSelected = _selectedType == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.divider, width: isSelected ? 2 : 1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    color: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : null,
                  ),
                  child: Row(
                    children: [
                      Icon(v['icon'] as IconData, size: 32, color: isSelected ? AppColors.primaryBlue : AppColors.textMedium),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((v['name'] as String).tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            Text('${v['seats']} ${'seats'.tr}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Text('\$${v['price']}', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryBlue, fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
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
                Text('total'.tr, style: Theme.of(context).textTheme.bodySmall),
                Text('\$${_vehicleTypes[_selectedType]['price']}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
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

  Widget _buildInfoBox(BuildContext context, IconData icon, String label, String value, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
