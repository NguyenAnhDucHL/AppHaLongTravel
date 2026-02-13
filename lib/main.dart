import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/l10n/app_translations.dart';
import 'package:quang_ninh_travel/core/services/language_service.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';
import 'package:quang_ninh_travel/core/services/api_service.dart';
import 'package:quang_ninh_travel/core/services/hotel_service.dart';
import 'package:quang_ninh_travel/core/services/cruise_service.dart';
import 'package:quang_ninh_travel/core/services/tour_service.dart';
import 'package:quang_ninh_travel/core/services/restaurant_service.dart';
import 'package:quang_ninh_travel/core/services/transport_service.dart';
import 'package:quang_ninh_travel/core/services/admin_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await Firebase.initializeApp();

  final languageService = LanguageService();
  await languageService.init();
  Get.put(languageService);
  
  final authService = AuthService();
  await authService.init();
  Get.put(authService);

  // Initialize API and other services
  final apiService = ApiService();
  await apiService.init();
  Get.put(apiService);

  Get.put(HotelService());
  Get.put(CruiseService());
  Get.put(TourService());
  Get.put(RestaurantService());
  Get.put(TransportService());
  Get.put(AdminService());
  
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
