import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactBottomSheet extends StatelessWidget {
  final String? phoneNumber;
  final String? email;
  final String? website;

  const ContactBottomSheet({
    super.key,
    this.phoneNumber,
    this.email,
    this.website,
  });

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      Get.snackbar('Error', 'Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'contact'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
            _buildContactItem(
              context,
              'call'.tr,
              phoneNumber!,
              () => _launchUrl('tel:$phoneNumber'),
            ),
             const Divider(height: 32, thickness: 1, color: AppColors.divider),
          ],
          
          if (email != null && email!.isNotEmpty) ...[
            _buildContactItem(
              context,
              'email'.tr,
              email!,
              () => _launchUrl('mailto:$email'),
            ),
             const Divider(height: 32, thickness: 1, color: AppColors.divider),
          ],
          
          if (website != null && website!.isNotEmpty) ...[
            _buildContactItem(
              context,
              'website'.tr,
              website!,
              () => _launchUrl(website!),
            ),
            const Divider(height: 32, thickness: 1, color: AppColors.divider),
          ],
          const SizedBox(height: AppTheme.spacingM),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black, // Ensure label is black/dark
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryBlue, // Value in Blue
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
