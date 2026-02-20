import 'package:get/get.dart';
import 'package:quang_ninh_travel/features/home/home_page.dart';
import 'package:quang_ninh_travel/features/hotels/hotels_page.dart';
import 'package:quang_ninh_travel/features/hotels/hotel_detail_page.dart';
import 'package:quang_ninh_travel/features/cruises/cruises_page.dart';
import 'package:quang_ninh_travel/features/cruises/cruise_detail_page.dart';
import 'package:quang_ninh_travel/features/transport/transport_page.dart';
import 'package:quang_ninh_travel/features/transport/transport_booking_page.dart';
import 'package:quang_ninh_travel/features/transport/transport_detail_page.dart';
import 'package:quang_ninh_travel/features/restaurants/restaurants_page.dart';
import 'package:quang_ninh_travel/features/restaurants/restaurant_detail_page.dart';
import 'package:quang_ninh_travel/features/tours/tours_page.dart';
import 'package:quang_ninh_travel/features/tours/tour_detail_page.dart';
import 'package:quang_ninh_travel/features/profile/profile_page.dart';
import 'package:quang_ninh_travel/features/profile/profile_edit_page.dart';
import 'package:quang_ninh_travel/features/bookings/my_bookings_page.dart';
import 'package:quang_ninh_travel/features/bookings/booking_detail_page.dart';
import 'package:quang_ninh_travel/features/bookings/booking_create_page.dart';
import 'package:quang_ninh_travel/features/favorites/favorites_page.dart';
import 'package:quang_ninh_travel/features/payment/payment_methods_page.dart';
import 'package:quang_ninh_travel/features/admin/admin_page.dart';
import 'package:quang_ninh_travel/features/admin/manage_users_page.dart';
import 'package:quang_ninh_travel/features/splash/splash_page.dart';
import 'package:quang_ninh_travel/features/onboarding/onboarding_page.dart';
import 'package:quang_ninh_travel/features/auth/login_page.dart';
import 'package:quang_ninh_travel/features/auth/register_page.dart';
import 'package:quang_ninh_travel/features/auth/forgot_password_page.dart';
import 'package:quang_ninh_travel/features/search/search_page.dart';
import 'package:quang_ninh_travel/features/checkout/checkout_page.dart';
import 'package:quang_ninh_travel/features/settings/settings_page.dart';
import 'package:quang_ninh_travel/features/notifications/notifications_page.dart';
import 'package:quang_ninh_travel/features/help/help_support_page.dart';
import 'package:quang_ninh_travel/features/reviews/write_review_page.dart';
import 'package:quang_ninh_travel/core/guards/auth_guard.dart';

part 'app_routes.dart';

/// GetX route configuration
class AppPages {
  static const String initial = Routes.splash;
  
  static final List<GetPage> routes = [
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.hotels,
      page: () => const HotelsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.hotelDetail,
      page: () => const HotelDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cruises,
      page: () => const CruisesPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cruiseDetail,
      page: () => const CruiseDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.transport,
      page: () => const TransportPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.transportBooking,
      page: () => const TransportBookingPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.transportDetail,
      page: () => const TransportDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.restaurants,
      page: () => const RestaurantsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.restaurantDetail,
      page: () => const RestaurantDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.tours,
      page: () => const ToursPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.tourDetail,
      page: () => const TourDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profileEdit,
      page: () => const ProfileEditPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.bookings,
      page: () => const MyBookingsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.bookingCreate,
      page: () => const BookingCreatePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.bookingDetail,
      page: () => const BookingDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.favorites,
      page: () => const FavoritesPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.paymentMethods,
      page: () => const PaymentMethodsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.admin,
      page: () => const AdminPage(),
      transition: Transition.rightToLeft,
      middlewares: [ManagementGuard()],
    ),
    GetPage(
      name: Routes.manageUsers,
      page: () => const ManageUsersPage(),
      transition: Transition.rightToLeft,
      middlewares: [AdminGuard()],
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.helpSupport,
      page: () => const HelpSupportPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.writeReview,
      page: () => const WriteReviewPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
