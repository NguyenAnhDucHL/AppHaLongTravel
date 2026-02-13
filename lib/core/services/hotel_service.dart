import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class HotelService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<Map<String, dynamic>>> listHotels({int page = 1, int limit = 20}) async {
    try {
      final res = await _api.get(ApiConfig.hotels, queryParameters: {'page': page, 'limit': limit});
      if (res.data['success'] == true) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      print('Error listing hotels: $e');
      return [];
    }
  }

  Future<bool> createHotel(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.hotels, data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateHotel(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('${ApiConfig.hotels}/$id', data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteHotel(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.hotels}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
