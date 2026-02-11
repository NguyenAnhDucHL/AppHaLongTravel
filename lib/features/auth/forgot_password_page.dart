import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: _emailSent ? _buildSuccessView(context) : _buildFormView(context),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.lock_reset, size: 48, color: AppColors.accentOrange),
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        Center(
          child: Text(
            'Quên mật khẩu',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Center(
          child: Text(
            'Nhập email để nhận link đặt lại mật khẩu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),

        Text('Email', style: _labelStyle()),
        const SizedBox(height: AppTheme.spacingS),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'your@email.com',
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textLight),
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
            fillColor: AppColors.backgroundLight,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: Obx(() {
            final authService = Get.find<AuthService>();
            return ElevatedButton(
              onPressed: authService.isLoading.value ? null : _handleResetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
                elevation: 2,
              ),
              child: authService.isLoading.value
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Gửi link đặt lại', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            );
          }),
        ),
        const SizedBox(height: AppTheme.spacingL),

        Center(
          child: TextButton(
            onPressed: () => Get.back(),
            child: const Text('← Quay lại đăng nhập', style: TextStyle(color: AppColors.primaryBlue)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mark_email_read, size: 50, color: AppColors.success),
        ),
        const SizedBox(height: 24),
        Text(
          'Đã gửi email!',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Chúng tôi đã gửi link đặt lại mật khẩu đến ${_emailController.text}. Vui lòng kiểm tra hộp thư.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
            ),
            child: const Text('Quay lại đăng nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _handleResetPassword,
          child: const Text('Gửi lại email', style: TextStyle(color: AppColors.accentOrange)),
        ),
      ],
    );
  }

  void _handleResetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar('Lỗi', 'Vui lòng nhập email hợp lệ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final authService = Get.find<AuthService>();
    final success = await authService.resetPassword(email);
    if (success) {
      setState(() => _emailSent = true);
    } else {
      Get.snackbar('Lỗi', 'Không thể gửi email. Vui lòng thử lại.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  TextStyle _labelStyle() => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
}
