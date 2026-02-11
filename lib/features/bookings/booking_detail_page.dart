import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('booking_details'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('booking_confirmed'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.success)),
                      Text('${'booking_id'.tr}: QN-2024-001', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Property Info
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: const Icon(Icons.hotel, color: AppColors.primaryBlue, size: 36),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hotel Paradise Premium', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Deluxe Room', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(5, (_) => const Icon(Icons.star, size: 14, color: AppColors.accentGold)),
                            Text(' 4.8', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Dates & Guests
            Text('booking_info'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(child: _buildDetailCard(context, Icons.calendar_today, 'check_in'.tr, '20 Feb 2024')),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(child: _buildDetailCard(context, Icons.calendar_today, 'check_out'.tr, '22 Feb 2024')),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(child: _buildDetailCard(context, Icons.nights_stay, 'nights'.tr, '2')),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(child: _buildDetailCard(context, Icons.people, 'guests'.tr, '2')),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Guest Info
            Text('guest_info'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            _buildInfoRow(context, 'full_name'.tr, 'Nguyễn Văn A'),
            _buildInfoRow(context, 'email'.tr, 'nguyen.a@email.com'),
            _buildInfoRow(context, 'phone'.tr, '+84 912 345 678'),
            const SizedBox(height: AppTheme.spacingL),

            // Payment
            Text('payment_info'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            _buildInfoRow(context, 'payment_method'.tr, 'MoMo'),
            _buildInfoRow(context, 'room_price'.tr, '\$240'),
            _buildInfoRow(context, 'service_fee'.tr, '\$24'),
            _buildInfoRow(context, 'taxes'.tr, '\$20'),
            const Divider(),
            _buildInfoRow(context, 'total'.tr, '\$284', isBold: true),
            const SizedBox(height: AppTheme.spacingL),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: Text('download_receipt'.tr),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                    label: Text('cancel_booking'.tr, style: const TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 22),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold
            ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
            : Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMedium)),
          Text(value, style: isBold
            ? Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)
            : Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
