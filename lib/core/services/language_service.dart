import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to persist and load language preference.
/// Supports: en_US, vi_VN, zh_CN
class LanguageService extends GetxService {
  static const String _langKey = 'app_language';

  final currentLang = 'en_US'.obs;

  /// Language options displayed in the picker
  static final List<Map<String, String>> languages = [
    {'code': 'en_US', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'vi_VN', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    {'code': 'zh_CN', 'name': '中文', 'flag': '🇨🇳'},
  ];

  Future<LanguageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_langKey);
    if (saved != null) {
      currentLang.value = saved;
      _applyLocale(saved);
    }
    return this;
  }

  Future<void> changeLanguage(String langCode) async {
    currentLang.value = langCode;
    _applyLocale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  void _applyLocale(String langCode) {
    final parts = langCode.split('_');
    final locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
    Get.updateLocale(locale);
  }

  /// Get display name for current language
  String get currentLanguageName {
    final match = languages.firstWhere(
      (l) => l['code'] == currentLang.value,
      orElse: () => languages.first,
    );
    return match['name']!;
  }
}
