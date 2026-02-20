import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class BookingService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    try {
      final res = await _api.post(ApiConfig.bookings, data: data);
      return res.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> listMyBookings() async {
    try {
      final res = await _api.get(ApiConfig.bookings);
      if (res.data['success'] == true) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> cancelBooking(String id) async {
    try {
      final res = await _api.put('${ApiConfig.bookings}/$id/cancel');
      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
