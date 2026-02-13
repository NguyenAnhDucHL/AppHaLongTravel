import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class AdminService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  // User Management
  Future<Map<String, dynamic>> listUsers({String? role, int page = 1, int limit = 20}) async {
    try {
      final res = await _api.get(ApiConfig.adminUsers, queryParameters: {
        if (role != null) 'role': role,
        'page': page,
        'limit': limit,
      });
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      return {'success': false, 'data': [], 'total': 0};
    }
  }

  Future<bool> setUserRole(String userId, String role, {List<String>? assignedServices}) async {
    try {
      final res = await _api.put('${ApiConfig.adminUsers}/$userId/role', data: {
        'role': role,
        if (assignedServices != null) 'assignedServices': assignedServices,
      });
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setUserActive(String userId, bool isActive) async {
    try {
      final res = await _api.put('${ApiConfig.adminUsers}/$userId/status', data: {'isActive': isActive});
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final res = await _api.delete('${ApiConfig.adminUsers}/$userId');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Stats
  Future<Map<String, dynamic>> getStats() async {
    try {
      final res = await _api.get(ApiConfig.adminStats);
      return Map<String, dynamic>.from(res.data['data']);
    } catch (e) {
      return {};
    }
  }

  // Deals & Destinations
  Future<List<Map<String, dynamic>>> listDeals() async {
    try {
      final res = await _api.get(ApiConfig.deals);
      return List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      return [];
    }
  }

  Future<bool> createDeal(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.deals, data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDeal(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.deals}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDeal(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('${ApiConfig.deals}/$id', data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> listDestinations() async {
    try {
      final res = await _api.get(ApiConfig.destinations);
      return List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      return [];
    }
  }

  Future<bool> createDestination(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.destinations, data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDestination(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('${ApiConfig.destinations}/$id', data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDestination(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.destinations}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Review Management
  Future<Map<String, dynamic>> listReviews({int page = 1, int limit = 20}) async {
    try {
      final res = await _api.get(ApiConfig.adminReviews, queryParameters: {'page': page, 'limit': limit});
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      return {'success': false, 'data': [], 'total': 0};
    }
  }

  Future<bool> updateReviewStatus(String id, String status) async {
    try {
      final res = await _api.put('${ApiConfig.adminReviews}/$id/status', data: {'status': status});
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteReview(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.adminReviews}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
