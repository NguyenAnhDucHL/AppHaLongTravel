import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User roles matching backend definition
enum UserRole { admin, collaborator, customer, guest }

/// Auth service for managing user authentication and role-based access.
/// Uses Firebase Auth and Firestore.
class AuthService extends GetxService {
  static const String _roleKey = 'user_role';
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Observable state
  final isLoggedIn = false.obs;
  final currentRole = UserRole.guest.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final userAvatar = ''.obs;
  final userBio = ''.obs;
  final userUid = ''.obs;
  final isLoading = false.obs;
  
  // Expose user for other services
  User? get currentUser => _auth.currentUser;

  /// Initialize — check current session
  Future<AuthService> init() async {
    // Listen to Auth State Changes
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        await _clearSession();
      } else {
        await _fetchUserProfile(user.uid);
      }
    });

    return this;
  }

  /// Login with email/password
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Auth state listener will handle the rest
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new account
  /// Register new account
  /// Returns null if success, otherwise returns error message
  Future<String?> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    isLoading.value = true;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        await _db.collection('users').doc(credential.user!.uid).set({
          'email': email,
          'displayName': name,
          'phoneNumber': phone,
          'role': 'customer', // Default role
          'photoURL': '',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        // Update Firebase Profile
        await credential.user!.updateDisplayName(name);
      }
      return null; // Success
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      return e.message ?? 'Lỗi xác thực không xác định';
    } catch (e) {
      print('Register general error: $e');
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? photoURL,
    String? bio,
  }) async {
    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final updates = <String, dynamic>{};
      if (name != null) {
        updates['displayName'] = name;
        await user.updateDisplayName(name);
      }
      if (phone != null) updates['phoneNumber'] = phone;
      if (photoURL != null) {
        updates['photoURL'] = photoURL;
        await user.updatePhotoURL(photoURL);
      }
      if (bio != null) updates['bio'] = bio;

      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await _db.collection('users').doc(user.uid).update(updates);
        
        // Refresh local state
        await _fetchUserProfile(user.uid);
      }
      
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _auth.signOut();
    } finally {
      isLoading.value = false;
    }
  }

  /// Send password reset email
  Future<bool> resetPassword(String email) async {
    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== HELPER METHODS =====

  Future<void> _fetchUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        
        isLoggedIn.value = true;
        userUid.value = uid;
        userEmail.value = data['email'] ?? '';
        userName.value = data['displayName'] ?? '';
        userPhone.value = data['phoneNumber'] ?? '';
        userAvatar.value = data['photoURL'] ?? '';
        userBio.value = data['bio'] ?? '';

        final roleStr = data['role'] ?? 'customer';
        currentRole.value = UserRole.values.firstWhere(
          (r) => r.name == roleStr,
          orElse: () => UserRole.customer,
        );
        
        // Cache role locally for offline checks if needed
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_roleKey, roleStr);
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);

    isLoggedIn.value = false;
    currentRole.value = UserRole.guest;
    userName.value = '';
    userEmail.value = '';
    userPhone.value = '';
    userAvatar.value = '';
    userBio.value = '';
    userUid.value = '';
  }

  // ===== ROLE CHECKS (Same as before) =====

  bool get isAdmin => currentRole.value == UserRole.admin;
  bool get isCollaborator => currentRole.value == UserRole.collaborator;
  bool get isCustomer => currentRole.value == UserRole.customer;
  bool get isGuest => currentRole.value == UserRole.guest || !isLoggedIn.value;

  bool hasPermission(String permission) {
    switch (currentRole.value) {
      case UserRole.admin:
        return true;
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

  bool get canAccessAdmin => isAdmin || isCollaborator;
  bool get canBook => isAdmin || isCollaborator || isCustomer;
  bool get canReview => isAdmin || isCustomer;

  String get initials {
    if (userName.value.isEmpty) return '?';
    final parts = userName.value.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return userName.value[0].toUpperCase() ?? '?';
  }

  String get roleDisplayName {
    switch (currentRole.value) {
      case UserRole.admin: return 'Quản trị viên';
      case UserRole.collaborator: return 'Cộng tác viên';
      case UserRole.customer: return 'Khách hàng';
      case UserRole.guest: return 'Khách';
    }
  }
}
