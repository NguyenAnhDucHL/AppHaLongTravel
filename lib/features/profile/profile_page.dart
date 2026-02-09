import 'package:flutter/material.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {},
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
                    'Guest User',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'guest@halongtravel.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In'),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 8),
            
            // Menu Items
            _buildMenuItem(
              context,
              icon: Icons.calendar_today,
              title: 'My Bookings',
              subtitle: 'View your reservations',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.favorite,
              title: 'Favorites',
              subtitle: 'Saved places',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.payment,
              title: 'Payment Methods',
              subtitle: 'Manage your cards',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'FAQs and contact us',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version 1.0.0',
              onTap: () {},
            ),
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
