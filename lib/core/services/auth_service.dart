import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User roles matching backend definition
enum UserRole { admin, collaborator, customer, guest }

/// Auth service for managing user authentication and role-based access.
/// Currently uses local state, ready for Firebase Auth integration.
class AuthService extends GetxService {
  static const String _roleKey = 'user_role';
  static const String _emailKey = 'user_email';
  static const String _nameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _uidKey = 'user_uid';
  static const String _avatarKey = 'user_avatar';
  static const String _phoneKey = 'user_phone';

  // Observable state
  final isLoggedIn = false.obs;
  final currentRole = UserRole.guest.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final userAvatar = ''.obs;
  final userUid = ''.obs;
  final isLoading = false.obs;

  /// Initialize — load saved session
  Future<AuthService> init() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool(_isLoggedInKey) ?? false;
    userName.value = prefs.getString(_nameKey) ?? '';
    userEmail.value = prefs.getString(_emailKey) ?? '';
    userPhone.value = prefs.getString(_phoneKey) ?? '';
    userAvatar.value = prefs.getString(_avatarKey) ?? '';
    userUid.value = prefs.getString(_uidKey) ?? '';

    final roleStr = prefs.getString(_roleKey) ?? 'guest';
    currentRole.value = UserRole.values.firstWhere(
      (r) => r.name == roleStr,
      orElse: () => UserRole.guest,
    );

    return this;
  }

  /// Login with email/password
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      // TODO: Replace with Firebase Auth signInWithEmailAndPassword
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate role lookup — in production, fetch from Firestore
      UserRole role = UserRole.customer;
      String name = 'Khách hàng';

      if (email.contains('admin')) {
        role = UserRole.admin;
        name = 'Quản trị viên';
      } else if (email.contains('collab') || email.contains('ctv')) {
        role = UserRole.collaborator;
        name = 'Cộng tác viên';
      }

      await _saveSession(
        uid: 'uid_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: role,
      );
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new account (always customer role)
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    isLoading.value = true;
    try {
      // TODO: Replace with Firebase Auth createUserWithEmailAndPassword
      await Future.delayed(const Duration(milliseconds: 800));

      await _saveSession(
        uid: 'uid_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: UserRole.customer,
        phone: phone,
      );
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    isLoading.value = true;
    try {
      // TODO: Firebase Auth signOut
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_roleKey);
      await prefs.remove(_emailKey);
      await prefs.remove(_nameKey);
      await prefs.remove(_uidKey);
      await prefs.remove(_avatarKey);
      await prefs.remove(_phoneKey);

      isLoggedIn.value = false;
      currentRole.value = UserRole.guest;
      userName.value = '';
      userEmail.value = '';
      userPhone.value = '';
      userAvatar.value = '';
      userUid.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  /// Send password reset email
  Future<bool> resetPassword(String email) async {
    isLoading.value = true;
    try {
      // TODO: Firebase Auth sendPasswordResetEmail
      await Future.delayed(const Duration(milliseconds: 600));
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ROLE CHECKS =====

  bool get isAdmin => currentRole.value == UserRole.admin;
  bool get isCollaborator => currentRole.value == UserRole.collaborator;
  bool get isCustomer => currentRole.value == UserRole.customer;
  bool get isGuest => currentRole.value == UserRole.guest || !isLoggedIn.value;

  /// Check if user has permission for a specific action
  bool hasPermission(String permission) {
    switch (currentRole.value) {
      case UserRole.admin:
        return true; // Admin has all permissions
      case UserRole.collaborator:
        return ['manage_assigned_services', 'view_bookings', 'respond_reviews', 'view_stats']
            .contains(permission);
      case UserRole.customer:
        return ['book_services', 'write_reviews', 'manage_favorites', 'view_bookings']
            .contains(permission);
      case UserRole.guest:
        return ['view_services'].contains(permission);
    }
  }

  /// Check if user can access admin panel
  bool get canAccessAdmin => isAdmin || isCollaborator;

  /// Check if user can book services
  bool get canBook => isAdmin || isCollaborator || isCustomer;

  /// Check if user can write reviews
  bool get canReview => isAdmin || isCustomer;

  /// User initials for avatar
  String get initials {
    if (userName.value.isEmpty) return '?';
    final parts = userName.value.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return userName.value[0].toUpperCase();
  }

  /// Role display name in Vietnamese
  String get roleDisplayName {
    switch (currentRole.value) {
      case UserRole.admin:
        return 'Quản trị viên';
      case UserRole.collaborator:
        return 'Cộng tác viên';
      case UserRole.customer:
        return 'Khách hàng';
      case UserRole.guest:
        return 'Khách';
    }
  }

  // ===== PRIVATE =====

  Future<void> _saveSession({
    required String uid,
    required String email,
    required String name,
    required UserRole role,
    String phone = '',
    String avatar = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_uidKey, uid);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_roleKey, role.name);
    await prefs.setString(_phoneKey, phone);
    await prefs.setString(_avatarKey, avatar);

    isLoggedIn.value = true;
    currentRole.value = role;
    userName.value = name;
    userEmail.value = email;
    userPhone.value = phone;
    userAvatar.value = avatar;
    userUid.value = uid;
  }
}
