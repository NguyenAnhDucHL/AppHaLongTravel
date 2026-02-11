import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class ManageHotelsPage extends StatefulWidget {
  const ManageHotelsPage({super.key});

  @override
  State<ManageHotelsPage> createState() => _ManageHotelsPageState();
}

class _ManageHotelsPageState extends State<ManageHotelsPage> {
  final List<Map<String, dynamic>> _hotels = [
    {
      'name': 'Paradise Suites Hotel',
      'location': 'Tuần Châu, Hạ Long',
      'price': 2500000,
      'rating': 4.8,
      'status': 'active',
      'rooms': 45,
      'category': 'luxury',
      'images': 3,
    },
    {
      'name': 'Novotel Ha Long Bay',
      'location': 'Bãi Cháy, Hạ Long',
      'price': 1800000,
      'rating': 4.6,
      'status': 'active',
      'rooms': 120,
      'category': 'luxury',
      'images': 5,
    },
    {
      'name': 'Wyndham Legend Halong',
      'location': 'Bãi Cháy, Hạ Long',
      'price': 3200000,
      'rating': 4.7,
      'status': 'active',
      'rooms': 80,
      'category': 'resort',
      'images': 4,
    },
    {
      'name': 'FLC Grand Hotel',
      'location': 'Hùng Thắng, Hạ Long',
      'price': 1500000,
      'rating': 4.4,
      'status': 'inactive',
      'rooms': 200,
      'category': 'resort',
      'images': 2,
    },
    {
      'name': 'Mường Thanh Luxury',
      'location': 'Trung tâm Hạ Long',
      'price': 1200000,
      'rating': 4.3,
      'status': 'active',
      'rooms': 150,
      'category': 'business',
      'images': 3,
    },
  ];

  String _searchQuery = '';
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = _hotels.where((h) {
      final matchSearch = h['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatus = _filterStatus == 'all' || h['status'] == _filterStatus;
      return matchSearch && matchStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Khách sạn'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Xuất Excel',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm KS', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            color: AppColors.backgroundWhite,
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm khách sạn...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Row(
                  children: [
                    _buildFilterChip('Tất cả', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Hoạt động', 'active'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Tạm dừng', 'inactive'),
                    const Spacer(),
                    Text('${filtered.length} kết quả', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          // Hotel List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: filtered.length,
              itemBuilder: (context, index) => _buildHotelCard(context, filtered[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final selected = _filterStatus == value;
    return FilterChip(
      label: Text(label, style: TextStyle(
        color: selected ? Colors.white : AppColors.textDark,
        fontSize: 12,
      )),
      selected: selected,
      onSelected: (_) => setState(() => _filterStatus = value),
      backgroundColor: AppColors.backgroundLight,
      selectedColor: AppColors.primaryBlue,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildHotelCard(BuildContext context, Map<String, dynamic> hotel) {
    final isActive = hotel['status'] == 'active';
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusL)),
      child: Column(
        children: [
          // Image placeholder
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue.withOpacity(0.2), AppColors.primaryLight.withOpacity(0.3)],
              ),
            ),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.hotel, size: 48, color: AppColors.primaryBlue)),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.success : AppColors.error,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'Hoạt động' : 'Tạm dừng',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('${hotel['images']} ảnh', style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(hotel['name'], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.accentGold),
                          const SizedBox(width: 2),
                          Text('${hotel['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(hotel['location'], style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoTag(Icons.bed, '${hotel['rooms']} phòng'),
                    const SizedBox(width: 8),
                    _buildInfoTag(Icons.category, hotel['category']),
                    const Spacer(),
                    Text(
                      '${_formatPrice(hotel['price'])} ₫/đêm',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showAddEditDialog(context, hotel: hotel),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Sửa'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryBlue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showImageManager(context, hotel['name']),
                        icon: const Icon(Icons.photo_library, size: 16),
                        label: const Text('Ảnh'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.accentOrange),
                          foregroundColor: AppColors.accentOrange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showDeleteConfirm(context, hotel['name']),
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      tooltip: 'Xóa',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textLight),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]}.');
  }

  void _showAddEditDialog(BuildContext context, {Map<String, dynamic>? hotel}) {
    final isEdit = hotel != null;
    final nameCtrl = TextEditingController(text: isEdit ? hotel['name'] : '');
    final locationCtrl = TextEditingController(text: isEdit ? hotel['location'] : '');
    final priceCtrl = TextEditingController(text: isEdit ? hotel['price'].toString() : '');
    final roomsCtrl = TextEditingController(text: isEdit ? hotel['rooms'].toString() : '');
    String category = isEdit ? hotel['category'] : 'luxury';
    final amenities = <String>['WiFi', 'Hồ bơi', 'Spa', 'Nhà hàng', 'Phòng gym', 'Bãi biển'];
    final selectedAmenities = <String>{'WiFi', 'Nhà hàng'};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.9,
          decoration: const BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      isEdit ? 'Sửa Khách sạn' : 'Thêm Khách sạn',
                      style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image upload area
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), style: BorderStyle.solid),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.primaryBlue),
                                SizedBox(height: 8),
                                Text('Nhấn để tải ảnh lên', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
                                Text('PNG, JPG (tối đa 5MB)', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField('Tên khách sạn *', nameCtrl, Icons.hotel),
                      const SizedBox(height: 16),
                      _buildTextField('Địa chỉ *', locationCtrl, Icons.location_on),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextField('Giá/đêm (₫) *', priceCtrl, Icons.attach_money, isNumber: true)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField('Số phòng', roomsCtrl, Icons.bed, isNumber: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Hạng khách sạn', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: ['luxury', 'resort', 'business', 'budget'].map((c) {
                          final selected = category == c;
                          final labels = {'luxury': '⭐ Sang trọng', 'resort': '🏖 Resort', 'business': '💼 Thương mại', 'budget': '💰 Bình dân'};
                          return ChoiceChip(
                            label: Text(labels[c]!, style: TextStyle(color: selected ? Colors.white : AppColors.textDark, fontSize: 13)),
                            selected: selected,
                            onSelected: (_) => setSheetState(() => category = c),
                            selectedColor: AppColors.primaryBlue,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text('Tiện ích', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: amenities.map((a) {
                          final selected = selectedAmenities.contains(a);
                          return FilterChip(
                            label: Text(a, style: TextStyle(color: selected ? Colors.white : AppColors.textDark, fontSize: 12)),
                            selected: selected,
                            onSelected: (s) => setSheetState(() => s ? selectedAmenities.add(a) : selectedAmenities.remove(a)),
                            selectedColor: AppColors.primaryBlue,
                            checkmarkColor: Colors.white,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Nhập mô tả chi tiết...',
                          filled: true,
                          fillColor: AppColors.backgroundLight,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity, height: 50,
                        child: ElevatedButton(
                          onPressed: () { Navigator.pop(ctx); _showSuccessSnackbar(isEdit ? 'Đã cập nhật khách sạn' : 'Đã thêm khách sạn mới'); },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(isEdit ? 'Lưu thay đổi' : 'Thêm khách sạn', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  void _showImageManager(BuildContext context, String hotelName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
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
                  Text('Ảnh — $hotelName', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8,
                ),
                itemCount: 4, // 3 existing + 1 add button
                itemBuilder: (ctx, i) {
                  if (i == 3) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, color: AppColors.primaryBlue),
                            SizedBox(height: 4),
                            Text('Thêm ảnh', style: TextStyle(fontSize: 11, color: AppColors.primaryBlue)),
                          ],
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Icon(Icons.image, size: 32, color: AppColors.textLight)),
                      ),
                      Positioned(
                        top: 4, right: 4,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      if (i == 0)
                        Positioned(
                          bottom: 4, left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.accentGold, borderRadius: BorderRadius.circular(8)),
                            child: const Text('Chính', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); _showSuccessSnackbar('Đã xóa $name'); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Text(msg)]),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
