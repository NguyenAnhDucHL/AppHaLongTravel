import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/routes/app_pages.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';
import 'package:ha_long_travel/core/l10n/app_translations.dart';
import 'package:ha_long_travel/core/services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize language service
  final languageService = LanguageService();
  await languageService.init();
  Get.put(languageService);
  
  runApp(const QuangNinhTravelApp());
}

class QuangNinhTravelApp extends StatelessWidget {
  const QuangNinhTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quang Ninh Travel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      // i18n
      translations: AppTranslations(),
      locale: _getInitialLocale(),
      fallbackLocale: const Locale('en', 'US'),
    );
  }

  Locale _getInitialLocale() {
    try {
      final langService = Get.find<LanguageService>();
      final parts = langService.currentLang.value.split('_');
      return Locale(parts[0], parts.length > 1 ? parts[1] : '');
    } catch (_) {
      return const Locale('en', 'US');
    }
  }
}
