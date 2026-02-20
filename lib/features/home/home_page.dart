import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';
import 'package:quang_ninh_travel/core/services/hotel_service.dart';
import 'package:quang_ninh_travel/core/services/cruise_service.dart';
import 'package:quang_ninh_travel/core/services/tour_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _hotelService = Get.find<HotelService>();
  final _cruiseService = Get.find<CruiseService>();
  final _tourService = Get.find<TourService>();

  // Data lists
  List<Map<String, dynamic>> _featuredDeals = [];
  List<Map<String, dynamic>> _popularDestinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    try {
      final hotels = await _hotelService.listHotels();
      final cruises = await _cruiseService.listCruises();
      final tours = await _tourService.listTours();

      // Mix and tag data for Featured Deals
      List<Map<String, dynamic>> deals = [];
      if (cruises.isNotEmpty) {
        deals.addAll(cruises.take(3).map((e) => {...e, 'itemType': 'cruise'}));
      }
      if (hotels.isNotEmpty) {
        deals.addAll(hotels.take(2).map((e) => {...e, 'itemType': 'hotel'}));
      }
      
      // Tag data for Popular Destinations (Tours)
      List<Map<String, dynamic>> destinations = [];
      if (tours.isNotEmpty) {
        destinations.addAll(tours.take(5).map((e) => {...e, 'itemType': 'tour'}));
      }

      if (mounted) {
        setState(() {
          _featuredDeals = deals..shuffle(); // Randomize a bit
          _popularDestinations = destinations;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching home data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              _buildAppBar(),
              
              // Hero Section with Carousel
              _buildHeroCarousel(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Services Grid
              _buildServicesSection(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Featured Deals
              _buildFeaturedDeals(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Popular Destinations
              _buildPopularDestinations(),
              
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
              Obx(() {
                final authService = Get.find<AuthService>();
                if (authService.isLoggedIn.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xin chào,', // TODO: Add to translations
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        authService.userName.value,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Slightly smaller for names
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'welcome_to'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'app_name'.tr,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundLight,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCarousel() {
    final heroImages = [
      {
        'title': 'hero_title_1'.tr,
        'subtitle': 'hero_subtitle_1'.tr,
        'image': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800',
      },
      {
        'title': 'hero_title_2'.tr,
        'subtitle': 'hero_subtitle_2'.tr,
        'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
      },
      {
        'title': 'hero_title_3'.tr,
        'subtitle': 'hero_subtitle_3'.tr,
        'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: heroImages.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.overlayGradient,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      item['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.landscape, size: 64, color: Colors.white),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: AppColors.overlayGradient,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['subtitle']!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {'icon': Icons.hotel, 'label': 'service_hotels'.tr, 'route': Routes.hotels, 'color': AppColors.primaryBlue},
      {'icon': Icons.directions_boat, 'label': 'service_cruises'.tr, 'route': Routes.cruises, 'color': AppColors.accentOrange},
      {'icon': Icons.directions_car, 'label': 'service_transport'.tr, 'route': Routes.transport, 'color': AppColors.accentCoral},
      {'icon': Icons.restaurant, 'label': 'service_restaurants'.tr, 'route': Routes.restaurants, 'color': AppColors.accentGold},
      {'icon': Icons.tour, 'label': 'service_tours'.tr, 'route': Routes.tours, 'color': AppColors.primaryLight},
      {'icon': Icons.person, 'label': 'service_profile'.tr, 'route': Routes.profile, 'color': AppColors.primaryDark},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Text(
            'our_services'.tr,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              childAspectRatio: 1,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return InkWell(
                onTap: () => Get.toNamed(service['route'] as String),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          color: (service['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          service['icon'] as IconData,
                          size: 32,
                          color: service['color'] as Color,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        service['label'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedDeals() {
    if (_isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }
    
    if (_featuredDeals.isEmpty) {
      return const SizedBox.shrink(); // Hide if no data
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'featured_deals'.tr, // Note: Ensure this key exists or use 'Ưu đãi nổi bật'
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.cruises), // Default to Cruises for deals
                child: Text('view_all'.tr),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        SizedBox(
          height: 240, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            itemCount: _featuredDeals.length,
            itemBuilder: (context, index) {
              final item = _featuredDeals[index];
              final images = item['images'] as List?;
              final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;
              final name = item['name'] ?? 'Unknown';
              final price = item['price'] ?? 0;
              final location = item['address'] ?? item['route'] ?? 'Quảng Ninh';

              return GestureDetector(
                onTap: () {
                  final type = item['itemType'];
                  final id = item['id'];
                  
                  if (id == null) {
                    print('Error: Item ID is null for $name');
                    return;
                  }

                  if (type == 'cruise') {
                    Get.toNamed(Routes.cruiseDetail, arguments: id);
                  } else if (type == 'hotel') {
                    Get.toNamed(Routes.hotelDetail, arguments: id);
                  } else if (type == 'tour') {
                    Get.toNamed(Routes.tourDetail, arguments: id);
                  }
                },
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: AppTheme.spacingM, bottom: 10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppTheme.radiusL),
                        ),
                        child: Container(
                          height: 140,
                          color: AppColors.primaryLight.withOpacity(0.3),
                          child: imageUrl != null
                              ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity)
                              : const Center(child: Icon(Icons.image, size: 48, color: AppColors.textLight)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${price}', 
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.accentOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDestinations() {
    if (_popularDestinations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'popular_destinations'.tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.tours),
                child: Text('view_all'.tr),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Column(
            children: List.generate(_popularDestinations.length, (index) {
              final item = _popularDestinations[index];
              final images = item['images'] as List?;
              final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;
              final name = item['name'] ?? 'Tour tham quan';
              final duration = item['duration'] ?? 'Trong ngày';
              
              return GestureDetector(
                onTap: () {
                  final id = item['id'];
                  if (id != null) {
                     Get.toNamed(Routes.tourDetail, arguments: id);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(AppTheme.radiusM),
                        ),
                        child: Container(
                          width: 100,
                          color: AppColors.primaryLight.withOpacity(0.3),
                          child: imageUrl != null 
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : const Icon(Icons.landscape, size: 40, color: AppColors.textLight),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                duration,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: AppTheme.spacingM),
                        child: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 1:
            Get.toNamed(Routes.search);
            break;
          case 2:
            Get.toNamed(Routes.bookings);
            break;
          case 3:
            Get.toNamed(Routes.favorites);
            break;
          case 4:
            Get.toNamed(Routes.profile);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: 'nav_home'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          activeIcon: const Icon(Icons.search),
          label: 'nav_search'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_today_outlined),
          activeIcon: const Icon(Icons.calendar_today),
          label: 'nav_bookings'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_outline),
          activeIcon: const Icon(Icons.favorite),
          label: 'nav_favorites'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: 'nav_profile'.tr,
        ),
      ],
    );
  }
}
