import 'package:get/get.dart';
import 'package:ha_long_travel/features/home/home_page.dart';
import 'package:ha_long_travel/features/hotels/hotels_page.dart';
import 'package:ha_long_travel/features/cruises/cruises_page.dart';
import 'package:ha_long_travel/features/transport/transport_page.dart';
import 'package:ha_long_travel/features/restaurants/restaurants_page.dart';
import 'package:ha_long_travel/features/tours/tours_page.dart';
import 'package:ha_long_travel/features/profile/profile_page.dart';

part 'app_routes.dart';

/// GetX route configuration
class AppPages {
  static const String initial = Routes.home;
  
  static final List<GetPage> routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.hotels,
      page: () => const HotelsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cruises,
      page: () => const CruisesPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.transport,
      page: () => const TransportPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.restaurants,
      page: () => const RestaurantsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.tours,
      page: () => const ToursPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
