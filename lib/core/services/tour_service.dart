import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class TourService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<Map<String, dynamic>>> listTours({int page = 1, int limit = 20}) async {
    try {
      final res = await _api.get(ApiConfig.tours, queryParameters: {'page': page, 'limit': limit});
      if (res.data['success'] == true) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createTour(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.tours, data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTour(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('${ApiConfig.tours}/$id', data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTour(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.tours}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
