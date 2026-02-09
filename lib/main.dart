import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/routes/app_pages.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

void main() {
  runApp(const HaLongTravelApp());
}

class HaLongTravelApp extends StatelessWidget {
  const HaLongTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ha Long Travel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
