import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/features/admin/manage_hotels_page.dart';
import 'package:quang_ninh_travel/features/admin/manage_cruises_page.dart';
import 'package:quang_ninh_travel/features/admin/manage_tours_page.dart';
import 'package:quang_ninh_travel/features/admin/manage_restaurants_page.dart';
import 'package:quang_ninh_travel/features/admin/manage_reviews_page.dart';
import 'package:quang_ninh_travel/features/admin/manage_deals_page.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';
import 'package:quang_ninh_travel/core/services/seed_service.dart';
import 'package:quang_ninh_travel/app/routes/app_pages.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern gradient AppBar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Admin Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF1565C0)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(right: -30, top: -20, child: Icon(Icons.admin_panel_settings, size: 160, color: Colors.white.withOpacity(0.06))),
                    Positioned(left: -15, bottom: -10, child: Icon(Icons.analytics, size: 100, color: Colors.white.withOpacity(0.04))),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.white)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white)),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Stats Cards =====
                  _buildStatsRow(context),
                  const SizedBox(height: 24),

                  // ===== Quick Actions =====
                  Text('Quản lý nhanh', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),

                  // ===== Management Grid =====
                  Text('Quản lý dịch vụ', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  _buildManagementGrid(context),
                  const SizedBox(height: 24),

                  // ===== Recent Bookings =====
                  Row(
                    children: [
                      Text('Đặt phòng gần đây', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildRecentBookings(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== STATS ROW =====
  Widget _buildStatsRow(BuildContext context) {
    final stats = [
      _StatData('Đặt phòng', '1,284', Icons.calendar_today, const Color(0xFF2196F3), '+12%'),
      _StatData('Doanh thu', '₫2.4B', Icons.trending_up, const Color(0xFF4CAF50), '+18%'),
      _StatData('Người dùng', '3,421', Icons.people, const Color(0xFFFF9800), '+8%'),
      _StatData('Đánh giá', '856', Icons.star, const Color(0xFFE91E63), '+24%'),
    ];

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final s = stats[i];
          return Container(
            width: 145,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [s.color.withOpacity(0.12), s.color.withOpacity(0.04)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: s.color.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(s.icon, size: 18, color: s.color),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(s.trend, style: const TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                  ),
                ]),
                Text(s.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: s.color)),
                Text(s.label, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===== QUICK ACTIONS =====
  Widget _buildQuickActions(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _quickAction(context, '🏨', 'Thêm KS', AppColors.primaryBlue, () => _navigateTo(context, const ManageHotelsPage())),
          const SizedBox(width: 10),
          _quickAction(context, '⛵', 'Thêm DT', Colors.cyan, () => _navigateTo(context, const ManageCruisesPage())),
          const SizedBox(width: 10),
          _quickAction(context, '🏔', 'Tạo Tour', AppColors.accentOrange, () => _navigateTo(context, const ManageToursPage())),
          const SizedBox(width: 10),
          _quickAction(context, '🍽', 'Thêm NH', AppColors.accentGold, () => _navigateTo(context, const ManageRestaurantsPage())),
          const SizedBox(width: 10),
          _quickAction(context, '🎁', 'Ưu đãi', AppColors.accentCoral, () => _navigateTo(context, const ManageDealsPage())),
          const SizedBox(width: 10),
          _quickAction(context, '☁️', 'Nạp Data', Colors.purple, () async {
             Get.dialog(const Center(child: CircularProgressIndicator()));
             final seedService = Get.put(SeedService());
             await seedService.seedData();
             Get.back(); // close loading
          }),
        ],
      ),
    );
  }

  Widget _quickAction(BuildContext context, String emoji, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  // ===== MANAGEMENT GRID =====
  Widget _buildManagementGrid(BuildContext context) {
    final items = [
      _MenuItem(Icons.hotel, 'Khách sạn', '5 đăng ký', AppColors.primaryBlue, const ManageHotelsPage()),
      _MenuItem(Icons.sailing, 'Du thuyền', '3 đăng ký', Colors.cyan, const ManageCruisesPage()),
      _MenuItem(Icons.terrain, 'Tour du lịch', '4 tour', AppColors.accentOrange, const ManageToursPage()),
      _MenuItem(Icons.restaurant, 'Nhà hàng', '3 đăng ký', AppColors.accentGold, const ManageRestaurantsPage()),
      _MenuItem(Icons.rate_review, 'Đánh giá', '2 chờ duyệt', const Color(0xFF9C27B0), const ManageReviewsPage()),
      _MenuItem(Icons.local_offer, 'Ưu đãi & Điểm đến', '3 đang chạy', AppColors.accentCoral, const ManageDealsPage()),
    ];

    // Add user management tile for admins
    final authService = Get.find<AuthService>();
    if (authService.isAdmin) {
      items.add(_MenuItem(Icons.people, 'Người dùng', '4 vai trò', const Color(0xFFE91E63), const SizedBox()));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () {
            if (item.label == 'Người dùng') {
              Get.toNamed(Routes.manageUsers);
            } else {
              _navigateTo(context, item.page);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: item.color.withOpacity(0.15)),
              boxShadow: [BoxShadow(color: item.color.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: item.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 14, color: item.color.withOpacity(0.5)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(item.subtitle, style: TextStyle(fontSize: 11, color: item.color)),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===== RECENT BOOKINGS =====
  Widget _buildRecentBookings(BuildContext context) {
    final bookings = [
      _BookingData('Nguyễn Văn A', 'Paradise Hotel', '₫2.500.000', 'Hôm nay', 'confirmed'),
      _BookingData('张三', 'Ambassador Cruise', '₫4.500.000', 'Hôm qua', 'pending'),
      _BookingData('Trần Thị B', 'Yên Tử Trek', '₫600.000', '2 ngày', 'completed'),
      _BookingData('李四', 'Phương Nam Restaurant', '₫850.000', '3 ngày', 'confirmed'),
    ];

    return Column(
      children: bookings.map((b) {
        final statusColors = {'confirmed': AppColors.success, 'pending': AppColors.accentOrange, 'completed': AppColors.primaryBlue};
        final statusLabels = {'confirmed': 'Xác nhận', 'pending': 'Chờ', 'completed': 'Hoàn thành'};
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: Text(b.user.substring(0, 1), style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.user, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(b.service, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(b.amount, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 14)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(color: statusColors[b.status], shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text(statusLabels[b.status]!, style: TextStyle(fontSize: 10, color: statusColors[b.status], fontWeight: FontWeight.w500)),
                ]),
              ]),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _StatData {
  final String label, value, trend;
  final IconData icon;
  final Color color;
  const _StatData(this.label, this.value, this.icon, this.color, this.trend);
}

class _MenuItem {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final Widget page;
  const _MenuItem(this.icon, this.label, this.subtitle, this.color, this.page);
}

class _BookingData {
  final String user, service, amount, date, status;
  const _BookingData(this.user, this.service, this.amount, this.date, this.status);
}
