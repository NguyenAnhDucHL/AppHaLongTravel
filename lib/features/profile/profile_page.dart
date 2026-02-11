import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';
import 'package:quang_ninh_travel/core/services/language_service.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

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
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  // Avatar with role badge
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: authService.isLoggedIn.value
                            ? _roleColor(authService.currentRole.value).withOpacity(0.15)
                            : AppColors.primaryLight.withOpacity(0.3),
                        child: authService.isLoggedIn.value
                            ? Text(
                                authService.initials,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: _roleColor(authService.currentRole.value),
                                ),
                              )
                            : const Icon(Icons.person, size: 50, color: AppColors.primaryBlue),
                      ),
                      if (authService.isLoggedIn.value)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _roleColor(authService.currentRole.value),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                            ),
                            child: Text(
                              _roleEmoji(authService.currentRole.value),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Name
                  Text(
                    authService.isLoggedIn.value ? authService.userName.value : 'guest_user'.tr,
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  // Email
                  Text(
                    authService.isLoggedIn.value ? authService.userEmail.value : 'Chưa đăng nhập',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                  ),

                  // Role badge
                  if (authService.isLoggedIn.value) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _roleColor(authService.currentRole.value).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _roleColor(authService.currentRole.value).withOpacity(0.3)),
                      ),
                      child: Text(
                        '${_roleEmoji(authService.currentRole.value)} ${authService.roleDisplayName}',
                        style: TextStyle(
                          color: _roleColor(authService.currentRole.value),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.spacingM),

                  // Login or Edit Profile button
                  if (!authService.isLoggedIn.value)
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(Routes.login),
                      icon: const Icon(Icons.login),
                      label: Text('sign_in'.tr),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => Get.toNamed(Routes.profileEdit),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Chỉnh sửa hồ sơ'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(thickness: 8),
            
            // Menu Items — role-based
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

            // Admin/Collaborator panel — only show for admin & collaborator
            if (authService.canAccessAdmin)
              _buildMenuItem(
                context,
                icon: Icons.admin_panel_settings,
                title: authService.isAdmin ? 'admin'.tr : 'Quản lý dịch vụ',
                subtitle: authService.isAdmin ? 'admin_panel'.tr : 'Dịch vụ của tôi',
                onTap: () => Get.toNamed(Routes.admin),
                iconColor: const Color(0xFFE91E63),
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

            // Logout button
            if (authService.isLoggedIn.value) ...[
              const SizedBox(height: AppTheme.spacingM),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text('Đăng xuất', style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      )),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFFE91E63);
      case UserRole.collaborator:
        return Colors.purple;
      case UserRole.customer:
        return AppColors.primaryBlue;
      case UserRole.guest:
        return AppColors.textLight;
    }
  }

  String _roleEmoji(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '👑';
      case UserRole.collaborator:
        return '🤝';
      case UserRole.customer:
        return '👤';
      case UserRole.guest:
        return '👻';
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final authService = Get.find<AuthService>();
              await authService.signOut();
              Get.offAllNamed(Routes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
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
    Color iconColor = AppColors.primaryBlue,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spacingS),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
        ),
        child: Icon(icon, color: iconColor),
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
