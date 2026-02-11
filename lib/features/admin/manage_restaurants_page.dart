import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class ManageRestaurantsPage extends StatefulWidget {
  const ManageRestaurantsPage({super.key});
  @override
  State<ManageRestaurantsPage> createState() => _ManageRestaurantsPageState();
}

class _ManageRestaurantsPageState extends State<ManageRestaurantsPage> {
  final _restaurants = [
    {'name': 'Nhà Hàng Phương Nam', 'cuisine': 'Hải sản', 'address': 'Bãi Cháy', 'rating': 4.5, 'priceRange': '\$\$', 'reviews': 520, 'status': 'active'},
    {'name': 'Quán Ăn Làng Chài', 'cuisine': 'Bình dân', 'address': 'Cái Dăm', 'rating': 4.3, 'priceRange': '\$', 'reviews': 350, 'status': 'active'},
    {'name': 'Cái Dăm Seafood Market', 'cuisine': 'Chợ hải sản', 'address': 'Chợ Cái Dăm', 'rating': 4.1, 'priceRange': '\$', 'reviews': 280, 'status': 'active'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Nhà hàng')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRestaurantForm(context),
        backgroundColor: AppColors.accentGold,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Nhà hàng', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: _restaurants.length,
        itemBuilder: (ctx, i) => _buildCard(ctx, _restaurants[i]),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(colors: [AppColors.accentGold.withOpacity(0.3), AppColors.accentOrange.withOpacity(0.15)]),
            ),
            child: Stack(children: [
              const Center(child: Icon(Icons.restaurant, size: 46, color: AppColors.accentGold)),
              Positioned(top: 8, right: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(20)),
                child: Text(r['status'] == 'active' ? 'Mở cửa' : 'Đóng cửa', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(r['name'] as String, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star, size: 14, color: AppColors.accentGold),
                    Text(' ${r['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ]),
                ),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                _tag(r['cuisine'] as String, AppColors.accentGold),
                const SizedBox(width: 8),
                _tag(r['priceRange'] as String, AppColors.success),
                const SizedBox(width: 8),
                Icon(Icons.location_on, size: 13, color: AppColors.textLight), const SizedBox(width: 2),
                Text(r['address'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text('${r['reviews']} đánh giá', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                const Spacer(),
                _iconBtn(Icons.edit, AppColors.primaryBlue, () => _showRestaurantForm(context, r: r)),
                const SizedBox(width: 6),
                _iconBtn(Icons.menu_book, AppColors.accentOrange, () => _showMenuEditor(context, r['name'] as String)),
                const SizedBox(width: 6),
                _iconBtn(Icons.photo_library, Colors.purple, () {}),
                const SizedBox(width: 6),
                _iconBtn(Icons.delete_outline, AppColors.error, () {}),
              ]),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
  );

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8),
    child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 18, color: color)),
  );

  void _showRestaurantForm(BuildContext context, {Map<String, dynamic>? r}) {
    final isEdit = r != null;
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.9,
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Text(isEdit ? 'Sửa Nhà hàng' : 'Thêm Nhà hàng', style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
          ])),
          const Divider(height: 1),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(onTap: () {}, child: Container(
              height: 130, decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.accentGold.withOpacity(0.3))),
              child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_photo_alternate, size: 36, color: AppColors.accentGold),
                SizedBox(height: 6), Text('Tải ảnh nhà hàng', style: TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w500)),
              ])),
            )),
            const SizedBox(height: 16),
            _field('Tên nhà hàng *', Icons.restaurant, isEdit ? r['name'] : ''),
            const SizedBox(height: 14),
            _field('Địa chỉ *', Icons.location_on, isEdit ? r['address'] : ''),
            const SizedBox(height: 14),
            _field('Số điện thoại', Icons.phone, ''),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _field('Giờ mở cửa', Icons.schedule, '10:00')),
              const SizedBox(width: 12),
              Expanded(child: _field('Giờ đóng cửa', Icons.schedule, '22:00')),
            ]),
            const SizedBox(height: 14),
            const Text('Loại ẩm thực', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: ['Hải sản', 'Việt Nam', 'Châu Á', 'BBQ', 'Chay', 'Đặc sản'].map((c) => FilterChip(
              label: Text(c, style: const TextStyle(fontSize: 12)), selected: c == 'Hải sản', onSelected: (_) {},
              selectedColor: AppColors.accentGold, checkmarkColor: Colors.white,
            )).toList()),
            const SizedBox(height: 14),
            const Text('Mức giá', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: ['\$ Bình dân', '\$\$ Trung bình', '\$\$\$ Cao cấp'].map((p) => ChoiceChip(
              label: Text(p), selected: false, onSelected: (_) {},
            )).toList()),
            const SizedBox(height: 14),
            const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Nhập mô tả...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGold, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(isEdit ? 'Lưu thay đổi' : 'Thêm nhà hàng', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            )),
            const SizedBox(height: 24),
          ]))),
        ]),
      ),
    );
  }

  Widget _field(String label, IconData icon, String initial) => TextField(
    controller: TextEditingController(text: initial),
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
  );

  void _showMenuEditor(BuildContext context, String name) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.8,
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Text('Thực đơn — $name', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
          ])),
          const Divider(height: 1),
          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
            _menuItem('Tôm hùm nướng', '850.000₫', true),
            _menuItem('Sò điệp nướng mỡ hành', '180.000₫', true),
            _menuItem('Cơm chiên hải sản', '120.000₫', false),
            _menuItem('Ghẹ hấp bia', '200.000₫', true),
            const SizedBox(height: 16),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Thêm món'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48))),
          ])),
        ]),
      ),
    );
  }

  Widget _menuItem(String name, String price, bool popular) => Container(
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.fastfood, color: AppColors.accentGold, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (popular) ...[const SizedBox(width: 6), Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: const Text('Hot', style: TextStyle(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold)),
          )],
        ]),
        Text(price, style: const TextStyle(fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
      ])),
      IconButton(onPressed: () {}, icon: const Icon(Icons.edit, size: 18, color: AppColors.textLight)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.delete, size: 18, color: AppColors.error)),
    ]),
  );
}
