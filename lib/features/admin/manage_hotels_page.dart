import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/hotel_service.dart';
import 'package:quang_ninh_travel/core/utils/storage_utils.dart';
import 'package:quang_ninh_travel/features/admin/widgets/location_picker.dart';
import 'dart:io';

class ManageHotelsPage extends StatefulWidget {
  const ManageHotelsPage({super.key});

  @override
  State<ManageHotelsPage> createState() => _ManageHotelsPageState();
}

class _ManageHotelsPageState extends State<ManageHotelsPage> {
  final HotelService _hotelService = Get.find<HotelService>();
  
  List<Map<String, dynamic>> _hotels = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    setState(() => _isLoading = true);
    try {
      final hotels = await _hotelService.listHotels();
      setState(() => _hotels = hotels);
    } catch (e) {
      _showErrorSnackbar('Lỗi khi tải danh sách khách sạn');
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('Không tìm thấy khách sạn nào'))
                    : ListView.builder(
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
                hotel['images'] != null && (hotel['images'] as List).isNotEmpty
                    ? Image.network(
                        hotel['images'][0],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.hotel, size: 48, color: AppColors.primaryBlue)),
                      )
                    : const Center(child: Icon(Icons.hotel, size: 48, color: AppColors.primaryBlue)),
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
                        Text('${(hotel['images'] as List?)?.length ?? 0} ảnh', style: const TextStyle(color: Colors.white, fontSize: 11)),
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
                      onPressed: () => _showDeleteConfirm(context, hotel),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HotelForm(
        hotel: hotel,
        onSubmit: (data, newImages, existingImages) async {
          final isEdit = hotel != null;
          try {
            List<String> imageUrls = [...existingImages];
            
            if (newImages.isNotEmpty) {
              final newUrls = await StorageUtils.uploadMultipleFiles(newImages, 'hotels');
              imageUrls.addAll(newUrls);
            }

            final hotelData = {
              ...data,
              'images': imageUrls,
              'status': 'active',
              'rating': isEdit ? hotel['rating'] : 5.0,
            };

            bool success;
            if (isEdit) {
              success = await _hotelService.updateHotel(hotel['id'], hotelData);
            } else {
              success = await _hotelService.createHotel(hotelData);
            }

            if (success) {
              if (ctx.mounted) Navigator.pop(ctx);
              _fetchHotels();
              if (mounted) _showSuccessSnackbar(isEdit ? 'Đã cập nhật khách sạn' : 'Đã thêm khách sạn mới');
            } else {
              if (mounted) _showErrorSnackbar('Lỗi khi lưu khách sạn');
            }
            return success;
          } catch (e) {
            if (mounted) _showErrorSnackbar('Đã có lỗi xảy ra: $e');
            return false;
          }
        },
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

  void _showDeleteConfirm(BuildContext context, Map<String, dynamic> hotel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${hotel['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _hotelService.deleteHotel(hotel['id']);
              if (success) {
                _fetchHotels();
                _showSuccessSnackbar('Đã xóa ${hotel['name']}');
              } else {
                _showErrorSnackbar('Lỗi khi xóa khách sạn');
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 8), Text(msg)]),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

class HotelForm extends StatefulWidget {
  final Map<String, dynamic>? hotel;
  final Future<bool> Function(Map<String, dynamic> data, List<File> newImages, List<String> existingImages) onSubmit;

  const HotelForm({super.key, this.hotel, required this.onSubmit});

  @override
  State<HotelForm> createState() => _HotelFormState();
}

class _HotelFormState extends State<HotelForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _roomsCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _descCtrl;
  
  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;
  double? _lat;
  double? _lng;

  final List<String> _currencies = ['VND', 'USD', 'CNY'];
  String _selectedCurrency = 'VND';

  @override
  void initState() {
    super.initState();
    final h = widget.hotel;
    final isEdit = h != null;
    _nameCtrl = TextEditingController(text: isEdit ? h['name'] : '');
    _priceCtrl = TextEditingController(text: isEdit ? h['price'].toString() : '');
    _roomsCtrl = TextEditingController(text: isEdit ? h['rooms'].toString() : '');
    _locationCtrl = TextEditingController(text: isEdit ? h['location'] : '');
    _categoryCtrl = TextEditingController(text: isEdit ? h['category'] : '5 Star');
    _descCtrl = TextEditingController(text: isEdit ? h['description'] ?? '' : '');
    
    if (isEdit && h['images'] != null) {
      _existingImageUrls = List<String>.from(h['images']);
    }
    if (isEdit && h['currency'] != null) {
      _selectedCurrency = h['currency'];
    }

    _lat = isEdit ? (h['lat']?.toDouble() ?? 20.9599) : 20.9599;
    _lng = isEdit ? (h['lng']?.toDouble() ?? 107.0425) : 107.0425;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _roomsCtrl.dispose();
    _locationCtrl.dispose();
    _categoryCtrl.dispose();
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
                  widget.hotel != null ? 'Sửa Khách sạn' : 'Thêm Khách sạn',
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
                                color: AppColors.primaryBlue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 32, color: AppColors.primaryBlue),
                                  SizedBox(height: 4),
                                  Text('Thêm ảnh', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12)),
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
                      label: 'Tên khách sạn *', 
                      controller: _nameCtrl, 
                      icon: Icons.hotel,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tên khách sạn' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Địa chỉ *', 
                      controller: _locationCtrl, 
                      icon: Icons.location_on,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập địa chỉ' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                  label: 'Giá *', 
                                  controller: _priceCtrl, 
                                  icon: Icons.attach_money,
                                  isNumber: true,
                                  validator: (v) {
                                    if (v?.isEmpty == true) return 'Nhập giá';
                                    if (int.tryParse(v!) == null) return 'Phải là số';
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 56, // Match text field height
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCurrency,
                                      isExpanded: true,
                                      items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                      onChanged: (v) { if(v != null) setState(() => _selectedCurrency = v); },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: 'Số phòng *', 
                            controller: _roomsCtrl, 
                            icon: Icons.meeting_room,
                            isNumber: true,
                            validator: (v) {
                              if (v?.isEmpty == true) return 'Nhập số phòng';
                              if (int.tryParse(v!) == null) return 'Phải là số';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Vị trí bản đồ', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    LocationPicker(
                      initialLat: _lat ?? 20.9599,
                      initialLng: _lng ?? 107.0425,
                      onLocationChanged: (lat, lng) {
                        setState(() {
                          _lat = lat;
                          _lng = lng;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text('Hạng khách sạn', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['5 Star', '4 Star', '3 Star', 'Resort', 'Homestay'].map((c) => ChoiceChip(
                        label: Text(c), 
                        selected: _categoryCtrl.text == c, 
                        onSelected: (s) { if(s) setState(() => _categoryCtrl.text = c); },
                        selectedColor: AppColors.primaryBlue,
                        backgroundColor: AppColors.backgroundLight,
                        labelStyle: TextStyle(color: _categoryCtrl.text == c ? Colors.white : AppColors.textDark),
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
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: _isSubmitting 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(widget.hotel != null ? 'Lưu thay đổi' : 'Thêm khách sạn', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.black54),
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1)),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      final data = {
        'name': _nameCtrl.text.trim(),
        'price': int.parse(_priceCtrl.text),
        'currency': _selectedCurrency,
        'rooms': int.parse(_roomsCtrl.text),
        'location': _locationCtrl.text.trim(),
        'category': _categoryCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'lat': _lat,
        'lng': _lng,
      };

      await widget.onSubmit(data, _newImages, _existingImageUrls);
      
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
