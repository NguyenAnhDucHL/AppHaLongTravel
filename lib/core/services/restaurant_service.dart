import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class RestaurantService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<Map<String, dynamic>>> listRestaurants({int page = 1, int limit = 20}) async {
    try {
      final res = await _api.get(ApiConfig.restaurants, queryParameters: {'page': page, 'limit': limit});
      if (res.data['success'] == true) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createRestaurant(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.restaurants, data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRestaurant(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('${ApiConfig.restaurants}/$id', data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRestaurant(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.restaurants}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
