import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/restaurant_service.dart';
import 'package:quang_ninh_travel/core/utils/storage_utils.dart';
import 'dart:io';

class ManageRestaurantsPage extends StatefulWidget {
  const ManageRestaurantsPage({super.key});
  @override
  State<ManageRestaurantsPage> createState() => _ManageRestaurantsPageState();
}

class _ManageRestaurantsPageState extends State<ManageRestaurantsPage> {
  final RestaurantService _restaurantService = Get.find<RestaurantService>();
  
  List<Map<String, dynamic>> _restaurants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    setState(() => _isLoading = true);
    try {
      final restaurants = await _restaurantService.listRestaurants();
      setState(() => _restaurants = restaurants);
    } catch (e) {
      _showErrorSnackbar('Lỗi khi tải danh sách nhà hàng');
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _restaurants.isEmpty
          ? const Center(child: Text('Không có dữ liệu nhà hàng'))
          : ListView.builder(
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
                    Text(' ${r['rating'] ?? 5.0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                Text('${r['reviews'] ?? 0} đánh giá', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                const Spacer(),
                _iconBtn(Icons.edit, AppColors.primaryBlue, () => _showRestaurantForm(context, r: r)),
                const SizedBox(width: 6),
                _iconBtn(Icons.menu_book, AppColors.accentOrange, () => _showMenuEditor(context, r)),
                const SizedBox(width: 6),
                _iconBtn(Icons.delete_outline, AppColors.error, () => _showDeleteConfirm(context, r)),
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
    final nameCtrl = TextEditingController(text: isEdit ? r['name'] : '');
    final addressCtrl = TextEditingController(text: isEdit ? r['address'] : '');
    final phoneCtrl = TextEditingController(text: isEdit ? (r['phone'] ?? '') : '');
    String priceRange = isEdit ? r['priceRange'] : '\$\$';

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          bool isSubmitting = false;
          File? pickedFile;

          return Container(
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
                GestureDetector(onTap: () async {
                  final file = await StorageUtils.pickImage();
                  if (file != null) setSheetState(() => pickedFile = file);
                }, child: Container(
                  height: 130, decoration: BoxDecoration(
                    color: AppColors.accentGold.withOpacity(0.05), 
                    borderRadius: BorderRadius.circular(16), 
                    border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
                    image: pickedFile != null ? DecorationImage(image: FileImage(pickedFile!), fit: BoxFit.cover) : null,
                  ),
                  child: pickedFile == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add_photo_alternate, size: 36, color: AppColors.accentGold),
                    SizedBox(height: 6), Text('Tải ảnh nhà hàng', style: TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w500)),
                  ])) : null,
                )),
                const SizedBox(height: 16),
                _field('Tên nhà hàng *', Icons.restaurant, nameCtrl),
                const SizedBox(height: 14),
                _field('Địa chỉ *', Icons.location_on, addressCtrl),
                const SizedBox(height: 14),
                _field('Số điện thoại', Icons.phone, phoneCtrl),
                const SizedBox(height: 14),
                const Text('Loại ẩm thực', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: ['Hải sản', 'Việt Nam', 'Châu Á', 'BBQ', 'Chay', 'Đặc sản'].map((c) => FilterChip(
                  label: Text(c, style: const TextStyle(fontSize: 12)), selected: c == (isEdit ? (r['cuisine'] ?? 'Hải sản') : 'Hải sản'), onSelected: (_) {},
                  selectedColor: AppColors.accentGold, checkmarkColor: Colors.white,
                )).toList()),
                const SizedBox(height: 14),
                const Text('Mức giá', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: ['\$', '\$\$', '\$\$\$'].map((p) => ChoiceChip(
                  label: Text(p), 
                  selected: priceRange == p, 
                  onSelected: (s) { if (s) setSheetState(() => priceRange = p); },
                  selectedColor: AppColors.accentGold,
                  labelStyle: TextStyle(color: priceRange == p ? Colors.white : AppColors.textDark),
                )).toList()),
                const SizedBox(height: 14),
                const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Nhập mô tả...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                  onPressed: isSubmitting ? null : () async {
                    if (nameCtrl.text.isEmpty || addressCtrl.text.isEmpty) {
                      _showErrorSnackbar('Vui lòng nhập tên và địa chỉ');
                      return;
                    }
                    setSheetState(() => isSubmitting = true);
                    try {
                      String? imageUrl;
                      if (pickedFile != null) imageUrl = await StorageUtils.uploadFile(pickedFile!, 'restaurants');

                      final data = {
                        'name': nameCtrl.text,
                        'address': addressCtrl.text,
                        'phone': phoneCtrl.text,
                        'cuisine': isEdit ? (r['cuisine'] ?? 'Hải sản') : 'Hải sản',
                        'priceRange': priceRange,
                        'status': 'active',
                        'rating': isEdit ? r['rating'] : 5.0,
                        if (imageUrl != null) 'images': [imageUrl] else if (isEdit) 'images': r['images'] ?? [],
                      };

                      bool success;
                      if (isEdit) {
                        success = await _restaurantService.updateRestaurant(r['id'], data);
                      } else {
                        success = await _restaurantService.createRestaurant(data);
                      }

                      if (success) {
                        Navigator.pop(ctx);
                        _fetchRestaurants();
                        _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã thêm nhà hàng');
                      } else {
                        _showErrorSnackbar('Lỗi hệ thống');
                      }
                    } finally {
                      if (ctx.mounted) setSheetState(() => isSubmitting = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGold, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: isSubmitting 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isEdit ? 'Lưu thay đổi' : 'Thêm nhà hàng', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                )),
                const SizedBox(height: 24),
              ]))),
            ]),
          );
        }
      ),
    );
  }

  Widget _field(String label, IconData icon, TextEditingController ctrl) => TextField(
    controller: ctrl,
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
  );

  void _showMenuEditor(BuildContext context, Map<String, dynamic> r) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.8,
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Text('Thực đơn — ${r['name']}', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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

  void _showDeleteConfirm(BuildContext context, Map<String, dynamic> r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${r['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _restaurantService.deleteRestaurant(r['id']);
              if (success) {
                _fetchRestaurants();
                _showSuccessSnackbar('Đã xóa ${r['name']}');
              } else {
                _showErrorSnackbar('Lỗi khi xóa nhà hàng');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating));
  }

  void _showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
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
