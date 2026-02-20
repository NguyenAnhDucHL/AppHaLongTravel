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
          SizedBox(
            height: 140,
            child: Stack(children: [
               Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(colors: [AppColors.accentGold.withOpacity(0.3), AppColors.accentOrange.withOpacity(0.15)]),
                  image: (r['images'] as List?)?.isNotEmpty == true
                      ? DecorationImage(
                          image: NetworkImage((r['images'] as List)[0]),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (r['images'] as List?)?.isEmpty == true
                    ? const Center(child: Icon(Icons.restaurant, size: 46, color: AppColors.accentGold))
                    : null,
              ),
              Positioned(top: 8, right: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: (r['status'] == 'active' ? AppColors.success : AppColors.textLight).withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                child: Text(r['status'] == 'active' ? 'Mở cửa' : 'Đóng cửa', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(r['name'] ?? 'Chưa đặt tên', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
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
                _tag(r['cuisine'] ?? 'Hải sản', AppColors.accentGold),
                const SizedBox(width: 8),
                _tag(r['priceRange'] ?? '\$\$', AppColors.success),
                const SizedBox(width: 8),
                Icon(Icons.location_on, size: 13, color: AppColors.textLight), const SizedBox(width: 2),
                Expanded(child: Text(r['address'] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textLight), maxLines: 1, overflow: TextOverflow.ellipsis)),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RestaurantForm(
        restaurant: r,
        onSubmit: (data, newImages, existingImages) async {
          final isEdit = r != null;
          try {
            List<String> imageUrls = [...existingImages];
            
            if (newImages.isNotEmpty) {
              final newUrls = await StorageUtils.uploadMultipleFiles(newImages, 'restaurants');
              imageUrls.addAll(newUrls);
            }

            final restaurantData = {
              ...data,
              'images': imageUrls,
              'status': 'active',
              'rating': isEdit ? r['rating'] : 5.0,
            };

            bool success;
            if (isEdit) {
              success = await _restaurantService.updateRestaurant(r['id'], restaurantData);
            } else {
              success = await _restaurantService.createRestaurant(restaurantData);
            }

            if (success) {
              Navigator.pop(ctx);
              _fetchRestaurants();
              _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã thêm nhà hàng');
            } else {
              _showErrorSnackbar('Lỗi hệ thống');
            }
            return success;
          } catch (e) {
            _showErrorSnackbar('Lỗi: $e');
            return false;
          }
        },
      ),
    );
  }

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

class RestaurantForm extends StatefulWidget {
  final Map<String, dynamic>? restaurant;
  final Future<bool> Function(Map<String, dynamic> data, List<File> newImages, List<String> existingImages) onSubmit;

  const RestaurantForm({super.key, this.restaurant, required this.onSubmit});

  @override
  State<RestaurantForm> createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _descCtrl;
  late String _cuisine;
  late String _priceRange;

  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final r = widget.restaurant;
    final isEdit = r != null;
    _nameCtrl = TextEditingController(text: isEdit ? r['name'] : '');
    _addressCtrl = TextEditingController(text: isEdit ? r['address'] : '');
    _phoneCtrl = TextEditingController(text: isEdit ? (r['phone'] ?? '') : '');
    _descCtrl = TextEditingController(text: isEdit ? r['description'] ?? '' : '');
    _cuisine = isEdit ? (r['cuisine'] ?? 'Hải sản') : 'Hải sản';
    _priceRange = isEdit ? r['priceRange'] : '\$\$';

    if (isEdit && r['images'] != null) {
      _existingImageUrls = List<String>.from(r['images']);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.restaurant != null ? 'Sửa Nhà hàng' : 'Thêm Nhà hàng',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hình ảnh', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final files = await StorageUtils.pickMultiImage();
                              if (files.isNotEmpty) setState(() => _newImages.addAll(files));
                            },
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.accentGold.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 32, color: AppColors.accentGold),
                                  SizedBox(height: 4),
                                  Text('Thêm ảnh', style: TextStyle(color: AppColors.accentGold, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          ..._existingImageUrls.asMap().entries.map((entry) {
                            return Stack(
                              children: [
                                Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(image: NetworkImage(entry.value), fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  top: 4, right: 16,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _existingImageUrls.removeAt(entry.key)),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          ..._newImages.asMap().entries.map((entry) {
                            return Stack(
                              children: [
                                Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(image: FileImage(entry.value), fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  top: 4, right: 16,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _newImages.removeAt(entry.key)),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildTextField(
                      label: 'Tên nhà hàng *', 
                      controller: _nameCtrl, 
                      icon: Icons.restaurant,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tên nhà hàng' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Địa chỉ *', 
                      controller: _addressCtrl, 
                      icon: Icons.location_on,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập địa chỉ' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Số điện thoại', 
                      controller: _phoneCtrl, 
                      icon: Icons.phone,
                      titleCase: false,
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Loại ẩm thực', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: ['Hải sản', 'Việt Nam', 'Châu Á', 'BBQ', 'Chay', 'Đặc sản'].map((c) => FilterChip(
                        label: Text(c, style: const TextStyle(fontSize: 12)), 
                        selected: c == _cuisine, 
                        onSelected: (s) { if(s) setState(() => _cuisine = c); },
                        selectedColor: AppColors.accentGold, 
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(color: c == _cuisine ? Colors.white : AppColors.textDark),
                        backgroundColor: AppColors.backgroundLight,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Mức giá', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['\$', '\$\$', '\$\$\$'].map((p) => ChoiceChip(
                        label: Text(p), 
                        selected: _priceRange == p, 
                        onSelected: (s) { if (s) setState(() => _priceRange = p); },
                        selectedColor: AppColors.accentGold,
                        backgroundColor: AppColors.backgroundLight,
                        labelStyle: TextStyle(color: _priceRange == p ? Colors.white : AppColors.textDark),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Nhập mô tả chi tiết...',
                        filled: true, 
                        fillColor: AppColors.backgroundLight, 
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity, height: 52,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGold, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: _isSubmitting 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(widget.restaurant != null ? 'Lưu thay đổi' : 'Thêm nhà hàng', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required TextEditingController controller, 
    required IconData icon, 
    bool isNumber = false,
    bool titleCase = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : (titleCase ? TextInputType.text : TextInputType.phone),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.black54),
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accentGold, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1)),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      final data = {
        'name': _nameCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'cuisine': _cuisine,
        'priceRange': _priceRange,
        'description': _descCtrl.text.trim(),
      };

      await widget.onSubmit(data, _newImages, _existingImageUrls);
      
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

