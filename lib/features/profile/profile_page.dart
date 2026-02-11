import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';
import 'package:ha_long_travel/app/routes/app_pages.dart';
import 'package:ha_long_travel/core/services/language_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_title'.tr),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                    child: const Icon(Icons.person, size: 50, color: AppColors.primaryBlue),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    'guest_user'.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'guest@quangninhtravel.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.login),
                    icon: const Icon(Icons.login),
                    label: Text('sign_in'.tr),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 8),
            
            // Menu Items
            _buildMenuItem(
              context,
              icon: Icons.calendar_today,
              title: 'my_bookings'.tr,
              subtitle: 'view_reservations'.tr,
              onTap: () => Get.toNamed(Routes.bookings),
            ),
            _buildMenuItem(
              context,
              icon: Icons.favorite,
              title: 'favorites'.tr,
              subtitle: 'saved_places'.tr,
              onTap: () => Get.toNamed(Routes.favorites),
            ),
            _buildMenuItem(
              context,
              icon: Icons.payment,
              title: 'payment_methods'.tr,
              subtitle: 'manage_cards'.tr,
              onTap: () => Get.toNamed(Routes.paymentMethods),
            ),
            // Language selector
            Obx(() {
              final langService = Get.find<LanguageService>();
              return _buildMenuItem(
                context,
                icon: Icons.language,
                title: 'language'.tr,
                subtitle: langService.currentLanguageName,
                onTap: () => _showLanguagePicker(context),
              );
            }),
            _buildMenuItem(
              context,
              icon: Icons.admin_panel_settings,
              title: 'admin'.tr,
              subtitle: 'admin_panel'.tr,
              onTap: () => Get.toNamed(Routes.admin),
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'help_support'.tr,
              subtitle: 'faqs_contact'.tr,
              onTap: () => Get.toNamed(Routes.helpSupport),
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'about'.tr,
              subtitle: 'app_version'.tr,
              onTap: () {},
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final langService = Get.find<LanguageService>();

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXL)),
        ),
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              'select_language'.tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),
            ...LanguageService.languages.map((lang) {
              return Obx(() {
                final isSelected = langService.currentLang.value == lang['code'];
                return ListTile(
                  onTap: () {
                    langService.changeLanguage(lang['code']!);
                    Get.back();
                  },
                  leading: Text(
                    lang['flag']!,
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(
                    lang['name']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isSelected ? AppColors.primaryBlue : AppColors.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primaryBlue)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  tileColor: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : null,
                );
              });
            }),
            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spacingS),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
        ),
        child: Icon(icon, color: AppColors.primaryBlue),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
