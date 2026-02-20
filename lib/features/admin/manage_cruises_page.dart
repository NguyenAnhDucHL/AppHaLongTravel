import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/cruise_service.dart';
import 'package:quang_ninh_travel/core/utils/storage_utils.dart';
import 'dart:io';

class ManageCruisesPage extends StatefulWidget {
  const ManageCruisesPage({super.key});
  @override
  State<ManageCruisesPage> createState() => _ManageCruisesPageState();
}

class _ManageCruisesPageState extends State<ManageCruisesPage> {
  final CruiseService _cruiseService = Get.find<CruiseService>();
  
  List<Map<String, dynamic>> _cruises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCruises();
  }

  Future<void> _fetchCruises() async {
    setState(() => _isLoading = true);
    try {
      final cruises = await _cruiseService.listCruises();
      setState(() => _cruises = cruises);
    } catch (e) {
      _showErrorSnackbar('Lỗi khi tải danh sách du thuyền');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Du thuyền')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCruiseForm(context),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Du thuyền', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _cruises.isEmpty
          ? const Center(child: Text('Không có dữ liệu du thuyền'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: _cruises.length,
              itemBuilder: (ctx, i) => _buildCruiseCard(ctx, _cruises[i]),
            ),
    );
  }

  Widget _buildCruiseCard(BuildContext context, Map<String, dynamic> cruise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              color: AppColors.backgroundLight,
            ),
            child: Stack(
              children: [
                cruise['images'] != null && (cruise['images'] as List).isNotEmpty
                    ? Image.network(
                        cruise['images'][0],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.sailing, size: 50, color: AppColors.primaryBlue)),
                      )
                    : const Center(child: Icon(Icons.sailing, size: 50, color: AppColors.primaryBlue)),
                Positioned(top: 8, right: 8, child: _statusBadge(cruise['status'])),
                Positioned(bottom: 8, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                    child: Text(cruise['duration'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(cruise['name'] ?? 'Chưa đặt tên', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                    _ratingBadge((cruise['rating'] ?? 0.0).toDouble()),
                  ],
                ),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.route, size: 14, color: AppColors.textLight), const SizedBox(width: 4),
                  Text(cruise['route'] ?? '', style: Theme.of(context).textTheme.bodySmall),
                ]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _infoChip(Icons.door_back_door, '${cruise['cabins'] ?? 0} cabin'),
                    const Spacer(),
                    Text('${_fmt(cruise['price'] ?? 0)} ₫/người', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () => _showCruiseForm(context, cruise: cruise), icon: const Icon(Icons.edit, size: 16), label: const Text('Sửa'))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => _showItineraryEditor(context, cruise),
                    icon: const Icon(Icons.map, size: 16), label: const Text('Lịch trình'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.accentOrange, side: const BorderSide(color: AppColors.accentOrange)),
                  )),
                  const SizedBox(width: 8),
                  IconButton(onPressed: () => _showDeleteConfirm(context, cruise), icon: const Icon(Icons.delete_outline, color: AppColors.error)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String? s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: s == 'active' ? AppColors.success : AppColors.error, borderRadius: BorderRadius.circular(20)),
    child: Text(s == 'active' ? 'Hoạt động' : 'Tạm dừng', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
  );

  Widget _ratingBadge(double r) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.star, size: 14, color: AppColors.accentGold), const SizedBox(width: 2),
      Text('$r', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    ]),
  );

  Widget _infoChip(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: AppColors.textLight), const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
    ]),
  );

  String _fmt(int p) => p.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');

  void _showCruiseForm(BuildContext context, {Map<String, dynamic>? cruise}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CruiseForm(
        cruise: cruise,
        onSubmit: (data, newImages, existingImages) async {
          final isEdit = cruise != null;
          try {
            List<String> imageUrls = [...existingImages];
            
            if (newImages.isNotEmpty) {
              final newUrls = await StorageUtils.uploadMultipleFiles(newImages, 'cruises');
              imageUrls.addAll(newUrls);
            }

            final cruiseData = {
              ...data,
              'images': imageUrls,
              'rating': isEdit ? cruise['rating'] : 5.0,
            };

            bool success;
            if (isEdit) {
              success = await _cruiseService.updateCruise(cruise['id'], cruiseData);
            } else {
              success = await _cruiseService.createCruise(cruiseData);
            }

            if (success) {
              Navigator.pop(ctx);
              _fetchCruises();
              _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã thêm thành công');
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

  Widget _itineraryTile(String time, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)),
            child: Text(time, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
          ])),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit, size: 18, color: AppColors.textLight)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete, size: 18, color: AppColors.error)),
        ],
      ),
    );
  }

  void _showItineraryEditor(BuildContext context, Map<String, dynamic> cruise) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              Text('Lịch trình — ${cruise['name']}', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
            ])),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _itineraryTile('08:00', 'Check-in tại cảng', 'Đón khách'),
                  _itineraryTile('12:00', 'Buffet trưa', 'Hải sản trên vịnh'),
                  _itineraryTile('15:00', 'Hang Sửng Sốt', 'Tham quan hang động'),
                  _itineraryTile('17:00', 'Chèo Kayak', 'Quanh làng chài'),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Thêm mốc thời gian'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, Map<String, dynamic> cruise) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${cruise['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _cruiseService.deleteCruise(cruise['id']);
              if (success) {
                _fetchCruises();
                _showSuccessSnackbar('Đã xóa ${cruise['name']}');
              } else {
                _showErrorSnackbar('Lỗi khi xóa du thuyền');
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
}

class CruiseForm extends StatefulWidget {
  final Map<String, dynamic>? cruise;
  final Future<bool> Function(Map<String, dynamic> data, List<File> newImages, List<String> existingImages) onSubmit;

  const CruiseForm({super.key, this.cruise, required this.onSubmit});

  @override
  State<CruiseForm> createState() => _CruiseFormState();
}

class _CruiseFormState extends State<CruiseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _routeCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _cabinsCtrl;
  late TextEditingController _descCtrl;
  late String _duration;
  
  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;

  final List<String> _currencies = ['VND', 'USD', 'CNY'];
  String _selectedCurrency = 'VND';

  @override
  void initState() {
    super.initState();
    final c = widget.cruise;
    final isEdit = c != null;
    _nameCtrl = TextEditingController(text: isEdit ? c['name'] : '');
    _routeCtrl = TextEditingController(text: isEdit ? c['route'] : '');
    _priceCtrl = TextEditingController(text: isEdit ? c['price'].toString() : '');
    _cabinsCtrl = TextEditingController(text: isEdit ? c['cabins'].toString() : '');
    _descCtrl = TextEditingController(text: isEdit ? c['description'] ?? '' : '');
    _duration = isEdit ? c['duration'] : '2N1Đ';

    if (isEdit && c['images'] != null) {
      _existingImageUrls = List<String>.from(c['images']);
    }
    if (isEdit && c['currency'] != null) {
      _selectedCurrency = c['currency'];
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _routeCtrl.dispose();
    _priceCtrl.dispose();
    _cabinsCtrl.dispose();
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
                  widget.cruise != null ? 'Sửa Du thuyền' : 'Thêm Du thuyền',
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
                      label: 'Tên du thuyền *', 
                      controller: _nameCtrl, 
                      icon: Icons.sailing,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tên' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Tuyến đường *', 
                      controller: _routeCtrl, 
                      icon: Icons.route,
                       validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tuyến đường' : null,
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
                                  label: 'Giá/người *', 
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
                            label: 'Số cabin *', 
                            controller: _cabinsCtrl, 
                            icon: Icons.door_back_door,
                            isNumber: true,
                            validator: (v) {
                              if (v?.isEmpty == true) return 'Nhập số cabin';
                              if (int.tryParse(v!) == null) return 'Phải là số';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Thời gian', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: ['1 ngày', '2N1Đ', '3N2Đ'].map((d) {
                        final selected = _duration == d;
                        return ChoiceChip(
                          label: Text(d, style: TextStyle(color: selected ? Colors.white : AppColors.textDark)),
                          selected: selected,
                          onSelected: (s) { if (s) setState(() => _duration = d); },
                          selectedColor: AppColors.primaryBlue,
                          backgroundColor: AppColors.backgroundLight,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Bao gồm', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: ['Bữa ăn', 'Kayak', 'Vé hang', 'Hướng dẫn', 'Xe đưa đón'].map((s) => FilterChip(
                        label: Text(s, style: const TextStyle(fontSize: 12)), 
                        selected: true, 
                        onSelected: (_) {},
                        selectedColor: AppColors.primaryBlue.withOpacity(0.1),
                        checkmarkColor: AppColors.primaryBlue,
                        labelStyle: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500),
                        backgroundColor: AppColors.backgroundLight,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                          : Text(widget.cruise != null ? 'Lưu thay đổi' : 'Thêm du thuyền', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
        'route': _routeCtrl.text.trim(),
        'price': int.parse(_priceCtrl.text),
        'currency': _selectedCurrency,
        'cabins': int.parse(_cabinsCtrl.text),
        'duration': _duration,
        'status': 'active',
        'description': _descCtrl.text.trim(),
      };

      await widget.onSubmit(data, _newImages, _existingImageUrls);
      
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

