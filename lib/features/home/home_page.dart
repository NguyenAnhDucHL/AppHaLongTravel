import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';
import 'package:ha_long_travel/app/routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _heroImages = [
    {
      'title': 'Discover Ha Long Bay',
      'subtitle': 'UNESCO World Heritage Site',
      'image': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800',
    },
    {
      'title': 'Luxury Cruises',
      'subtitle': 'Unforgettable Experiences',
      'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
    },
    {
      'title': 'Premium Hotels',
      'subtitle': 'Comfort & Elegance',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
    },
  ];

  final List<Map<String, dynamic>> _services = [
    {'icon': Icons.hotel, 'label': 'Hotels', 'route': Routes.hotels, 'color': AppColors.primaryBlue},
    {'icon': Icons.directions_boat, 'label': 'Cruises', 'route': Routes.cruises, 'color': AppColors.accentOrange},
    {'icon': Icons.directions_car, 'label': 'Transport', 'route': Routes.transport, 'color': AppColors.accentCoral},
    {'icon': Icons.restaurant, 'label': 'Restaurants', 'route': Routes.restaurants, 'color': AppColors.accentGold},
    {'icon': Icons.tour, 'label': 'Tours', 'route': Routes.tours, 'color': AppColors.primaryLight},
    {'icon': Icons.person, 'label': 'Profile', 'route': Routes.profile, 'color': AppColors.primaryDark},
  ];

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Ha Long Travel',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: _heroImages.map((item) {
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
                      item['image'],
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
                            item['title'],
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['subtitle'],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Text(
            'Our Services',
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
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return InkWell(
                onTap: () => Get.toNamed(service['route']),
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
                          service['icon'],
                          size: 32,
                          color: service['color'],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        service['label'],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Deals',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: AppTheme.spacingM),
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
                        child: const Center(
                          child: Icon(Icons.image, size: 48, color: AppColors.textLight),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Special Package ${index + 1}',
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
                                  'Ha Long Bay',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${(index + 1) * 50}',
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Text(
            'Popular Destinations',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Column(
            children: List.generate(3, (index) {
              return Container(
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
                        child: const Icon(Icons.landscape, size: 40, color: AppColors.textLight),
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
                              'Destination ${index + 1}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                            Text(
                              'Popular tourist spot in Ha Long',
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
        // Navigate based on index
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
