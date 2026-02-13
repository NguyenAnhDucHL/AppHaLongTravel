import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class TransportService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<Map<String, dynamic>>> listVehicles() async {
    try {
      final res = await _api.get('${ApiConfig.transport}/vehicles');
      if (res.data['success'] == true) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createTransport(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.transport, data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTransport(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('${ApiConfig.transport}/$id', data: data);
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTransport(String id) async {
    try {
      final res = await _api.delete('${ApiConfig.transport}/$id');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
