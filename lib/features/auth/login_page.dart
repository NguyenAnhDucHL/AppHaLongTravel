import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.sailing,
                        size: 48,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      'welcome_back'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'login_subtitle'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Error Message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13))),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
              ],

              // Email Field
              Text('email'.tr, style: _labelStyle()),
              const SizedBox(height: AppTheme.spacingS),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() => _errorMessage = null),
                decoration: InputDecoration(
                  hintText: 'email_hint'.tr,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
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
              const SizedBox(height: 16),

              // Password Field
              Text('password'.tr, style: _labelStyle()),
              const SizedBox(height: AppTheme.spacingS),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (_) => setState(() => _errorMessage = null),
                decoration: InputDecoration(
                  hintText: 'password_hint'.tr,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textLight,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
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
              const SizedBox(height: AppTheme.spacingM),

              // Remember + Forgot
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v!),
                    activeColor: AppColors.primaryBlue,
                  ),
                  Text('remember_me'.tr, style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.forgotPassword),
                    child: Text(
                      'forgot_password'.tr,
                      style: const TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() {
                  final authService = Get.find<AuthService>();
                  return ElevatedButton(
                    onPressed: authService.isLoading.value ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      elevation: 2,
                    ),
                    child: authService.isLoading.value
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('sign_in'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  );
                }),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Guest access
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed(Routes.home),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
                  ),
                  child: Text('Tiếp tục với tư cách Khách', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Register Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('no_account'.tr, style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.register),
                      child: Text(
                        'sign_up'.tr,
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                    child: Text('or_continue_with'.tr, style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Social Login Buttons
              // Social Login Buttons - Compact
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIconBtn(Icons.g_mobiledata, const Color(0xFFDB4437)),
                  const SizedBox(width: 20),
                  _buildSocialIconBtn(Icons.facebook, const Color(0xFF1877F2)),
                  const SizedBox(width: 20),
                  _buildSocialIconBtn(Icons.phone_android, const Color(0xFF0068FF)), // Zalo
                  const SizedBox(width: 20),
                  _buildSocialIconBtn(Icons.chat_bubble, const Color(0xFF07C160)), // WeChat
                ],
              ),
              const SizedBox(height: AppTheme.spacingXL),



              // Role hint (for demo)

            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập email');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập mật khẩu');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _errorMessage = 'Email không hợp lệ');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    final authService = Get.find<AuthService>();
    final success = await authService.login(email, password);

    if (success) {
      // Navigate based on role
      Get.snackbar(
        '🎉 Đăng nhập thành công!',
        'Xin chào ${authService.userName.value} (${authService.roleDisplayName})',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.success.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      if (authService.isAdmin) {
        Get.offAllNamed(Routes.admin);
      } else {
        Get.offAllNamed(Routes.home);
      }
    } else {
      setState(() => _errorMessage = 'Đăng nhập thất bại. Vui lòng kiểm tra lại email và mật khẩu.');
    }
  }

  TextStyle _labelStyle() {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    );
  }

  Widget _buildSocialIconBtn(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.divider),
          color: Colors.white,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
