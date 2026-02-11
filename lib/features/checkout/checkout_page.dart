import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  DateTime _checkIn = DateTime.now().add(const Duration(days: 7));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 9));
  int _guests = 2;
  int _selectedPayment = 0;

  final _paymentMethods = [
    {'name': 'Visa •••• 4242', 'icon': Icons.credit_card},
    {'name': 'MoMo', 'icon': Icons.phone_android},
    {'name': 'VNPay', 'icon': Icons.qr_code},
    {'name': 'ZaloPay', 'icon': Icons.account_balance_wallet},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('checkout'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary
            Text('booking_summary'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: const Icon(Icons.hotel, color: AppColors.primaryBlue),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hotel Paradise Premium', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: AppColors.accentGold),
                            Text(' 4.8 • Deluxe Room', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Date Selection
            Text('select_dates'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(child: _buildDatePicker(context, 'check_in'.tr, _checkIn, (d) => setState(() => _checkIn = d))),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(child: _buildDatePicker(context, 'check_out'.tr, _checkOut, (d) => setState(() => _checkOut = d))),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Guests
            Text('guests'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM, vertical: AppTheme.spacingS),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primaryBlue,
                  ),
                  Text('$_guests ${'guests'.tr}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _guests < 10 ? () => setState(() => _guests++) : null,
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Payment Method
            Text('payment_method'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            ...List.generate(_paymentMethods.length, (i) {
              final pm = _paymentMethods[i];
              return RadioListTile<int>(
                value: i,
                groupValue: _selectedPayment,
                onChanged: (v) => setState(() => _selectedPayment = v!),
                activeColor: AppColors.primaryBlue,
                title: Row(
                  children: [
                    Icon(pm['icon'] as IconData, color: AppColors.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(pm['name'] as String),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  side: BorderSide(color: _selectedPayment == i ? AppColors.primaryBlue : AppColors.divider),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              );
            }),
            const SizedBox(height: AppTheme.spacingL),

            // Price Breakdown
            Text('price_details'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            _buildPriceRow(context, 'room_price'.tr, '\$240'),
            _buildPriceRow(context, 'service_fee'.tr, '\$24'),
            _buildPriceRow(context, 'taxes'.tr, '\$20'),
            const Divider(height: 24),
            _buildPriceRow(context, 'total'.tr, '\$284', isTotal: true),
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
                Text('\$284', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: AppTheme.spacingL),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showBookingConfirmation(context),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text('confirm_booking'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, DateTime date, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('${date.day}/${date.month}/${date.year}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String price, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal
            ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
            : Theme.of(context).textTheme.bodyMedium),
          Text(price, style: isTotal
            ? Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)
            : Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusL)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 64),
            const SizedBox(height: AppTheme.spacingM),
            Text('booking_confirmed'.tr, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingS),
            Text('booking_confirmed_sub'.tr, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.offAllNamed(Routes.home);
              },
              child: Text('back_to_home'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
