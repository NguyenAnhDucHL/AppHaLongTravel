import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class CruiseService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<Map<String, dynamic>>> listCruises({int page = 1, int limit = 20}) async {
    try {
      final res = await _api.get(ApiConfig.cruises, queryParameters: {'page': page, 'limit': limit});
      if (res.data['success'] == true) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createCruise(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.cruises, data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCruise(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('${ApiConfig.cruises}/$id', data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCruise(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.cruises}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
