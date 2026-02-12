import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  String _selectedGender = 'male';
  
  final _authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _authService.userName.value);
    _emailController = TextEditingController(text: _authService.userEmail.value);
    _phoneController = TextEditingController(text: _authService.userPhone.value);
    _bioController = TextEditingController(text: _authService.userBio.value);
    
    // Listen to changes if needed, but for edit page usually we set once
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }
  
  Future<void> _handleSave() async {
    final success = await _authService.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      bio: _bioController.text.trim(),
    );
    
    if (success) {
      Get.back();
      Get.snackbar(
        'success'.tr, 
        'profile_updated'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'error'.tr, 
        'update_failed'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_profile'.tr),
        actions: [
          TextButton(
            onPressed: _authService.isLoading.value ? null : _handleSave,
            child: Obx(() => _authService.isLoading.value 
              ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(strokeWidth: 2)
                )
              : Text('save'.tr, style: const TextStyle(fontWeight: FontWeight.bold))
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    final avatarUrl = _authService.userAvatar.value;
                    return CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                      backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl.isEmpty 
                        ? const Icon(Icons.person, size: 55, color: AppColors.primaryBlue)
                        : null,
                    );
                  }),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Fields
            _buildField(context, 'full_name'.tr, _nameController, Icons.person_outline),
            const SizedBox(height: AppTheme.spacingM),
            _buildField(context, 'email'.tr, _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: AppTheme.spacingM),
            _buildField(context, 'phone'.tr, _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: AppTheme.spacingM),

            // Gender
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('gender'.tr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppTheme.spacingS),
                Row(
                  children: [
                    _buildGenderChip(context, 'male'.tr, 'male'),
                    const SizedBox(width: AppTheme.spacingM),
                    _buildGenderChip(context, 'female'.tr, 'female'),
                    const SizedBox(width: AppTheme.spacingM),
                    _buildGenderChip(context, 'other'.tr, 'other'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Bio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('bio'.tr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppTheme.spacingS),
                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'bio_hint'.tr,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Delete Account
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete_forever, color: AppColors.error),
              label: Text('delete_account'.tr, style: const TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppTheme.spacingS),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: label == 'email'.tr, // Email should be read-only usually
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textLight),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
            filled: true,
            fillColor: label == 'email'.tr ? Colors.grey[100] : AppColors.backgroundLight,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderChip(BuildContext context, String label, String value) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryBlue,
        labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textMedium),
        onSelected: (_) => setState(() => _selectedGender = value),
      ),
    );
  }
}
