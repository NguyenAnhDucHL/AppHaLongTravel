import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';

/// Route guard for role-based access control.
/// Add to GetPage middleware to protect routes.
class AuthGuard extends GetMiddleware {
  final List<UserRole> allowedRoles;

  AuthGuard({this.allowedRoles = const []});

  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    // If no specific roles required, just check if logged in
    if (allowedRoles.isEmpty) {
      if (!authService.isLoggedIn.value) {
        return const RouteSettings(name: Routes.login);
      }
      return null;
    }

    // Check if user has required role
    if (!authService.isLoggedIn.value) {
      return const RouteSettings(name: Routes.login);
    }

    if (!allowedRoles.contains(authService.currentRole.value)) {
      // Show snackbar with access denied message
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Truy cập bị từ chối',
          'Bạn cần quyền ${_roleNames(allowedRoles)} để truy cập trang này',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 3),
        );
      });
      return const RouteSettings(name: Routes.home);
    }

    return null; // Allow access
  }

  String _roleNames(List<UserRole> roles) {
    final names = {
      UserRole.admin: 'Quản trị viên',
      UserRole.collaborator: 'Cộng tác viên',
      UserRole.customer: 'Khách hàng',
      UserRole.guest: 'Khách',
    };
    return roles.map((r) => names[r]).join(' hoặc ');
  }
}

/// Guard that requires login (any authenticated user)
class RequireAuthGuard extends AuthGuard {
  RequireAuthGuard()
      : super(allowedRoles: [
          UserRole.admin,
          UserRole.collaborator,
          UserRole.customer,
        ]);
}

/// Guard that requires admin access
class AdminGuard extends AuthGuard {
  AdminGuard() : super(allowedRoles: [UserRole.admin]);
}

/// Guard that requires admin or collaborator access
class ManagementGuard extends AuthGuard {
  ManagementGuard()
      : super(allowedRoles: [UserRole.admin, UserRole.collaborator]);
}
