import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';
import 'package:quang_ninh_travel/core/services/language_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader(context, 'account_settings'.tr),
          _buildTile(context, Icons.person_outline, 'edit_profile'.tr, onTap: () => Get.toNamed(Routes.profileEdit)),
          _buildTile(context, Icons.lock_outline, 'change_password'.tr, onTap: () {}),
          _buildTile(context, Icons.notifications_outlined, 'notification_settings'.tr, onTap: () {}),
          _buildTile(context, Icons.security, 'privacy_security'.tr, onTap: () {}),

          const Divider(height: 32),

          // Preferences Section
          _buildSectionHeader(context, 'preferences'.tr),
          // Language
          Obx(() {
            final langService = Get.find<LanguageService>();
            return _buildTile(
              context, Icons.language, 'language'.tr,
              subtitle: langService.currentLanguageName,
              onTap: () => _showLanguagePicker(context),
            );
          }),
          _buildSwitchTile(context, Icons.dark_mode, 'dark_mode'.tr, false, (_) {}),
          _buildTile(context, Icons.monetization_on_outlined, 'currency'.tr, subtitle: 'USD (\$)', onTap: () {}),

          const Divider(height: 32),

          // Support Section
          _buildSectionHeader(context, 'support'.tr),
          _buildTile(context, Icons.help_outline, 'help_center'.tr, onTap: () => Get.toNamed(Routes.helpSupport)),
          _buildTile(context, Icons.chat_outlined, 'contact_us'.tr, onTap: () {}),
          _buildTile(context, Icons.star_outline, 'rate_app'.tr, onTap: () {}),
          _buildTile(context, Icons.info_outline, 'about'.tr, subtitle: 'v1.0.0', onTap: () {}),

          const Divider(height: 32),

          // Danger Zone
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text('sign_out'.tr, style: const TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
        ],
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: AppTheme.spacingL),
            Text('select_language'.tr, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppTheme.spacingL),
            ...LanguageService.languages.map((lang) {
              return Obx(() {
                final isSelected = langService.currentLang.value == lang['code'];
                return ListTile(
                  onTap: () { langService.changeLanguage(lang['code']!); Get.back(); },
                  leading: Text(lang['flag']!, style: const TextStyle(fontSize: 28)),
                  title: Text(lang['name']!, style: TextStyle(
                    color: isSelected ? AppColors.primaryBlue : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  )),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primaryBlue) : null,
                  tileColor: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
                );
              });
            }),
            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.spacingM, AppTheme.spacingM, AppTheme.spacingM, AppTheme.spacingS),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textLight, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, {String? subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(BuildContext context, IconData icon, String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryBlue,
    );
  }
}
