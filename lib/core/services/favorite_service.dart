import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/config/api_config.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';

class FavoriteService extends GetxService {
  final ApiService _api = Get.find<ApiService>();
  final RxList<String> _favoriteIds = <String>[].obs;

  List<String> get favoriteIds => _favoriteIds;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final res = await _api.get(ApiConfig.favorites);
      if (res.data['success'] == true) {
        final List<Map<String, dynamic>> favorites = List<Map<String, dynamic>>.from(res.data['data']);
        _favoriteIds.assignAll(favorites.map((e) => e['itemId'] as String).toList());
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listFavorites() async {
    try {
      final res = await _api.get(ApiConfig.favorites);
      if (res.data['success'] == true) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> toggleFavorite(String itemId, String itemType) async {
    try {
      final res = await _api.post(ApiConfig.favorites, data: {
        'itemId': itemId,
        'itemType': itemType,
      });
      
      if (res.data['success'] == true) {
        if (_favoriteIds.contains(itemId)) {
          _favoriteIds.remove(itemId);
        } else {
          _favoriteIds.add(itemId);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool isFavorite(String itemId) {
    return _favoriteIds.contains(itemId);
  }
}
