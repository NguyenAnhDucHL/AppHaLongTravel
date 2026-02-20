import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/tour_service.dart';
import 'package:quang_ninh_travel/core/utils/storage_utils.dart';
import 'dart:io';

class ManageToursPage extends StatefulWidget {
  const ManageToursPage({super.key});
  @override
  State<ManageToursPage> createState() => _ManageToursPageState();
}

class _ManageToursPageState extends State<ManageToursPage> {
  final TourService _tourService = Get.find<TourService>();
  
  List<Map<String, dynamic>> _tours = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTours();
  }

  Future<void> _fetchTours() async {
    setState(() => _isLoading = true);
    try {
      final tours = await _tourService.listTours();
      setState(() => _tours = tours);
    } catch (e) {
      _showErrorSnackbar('Lỗi khi tải danh sách tour');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Tour du lịch')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTourForm(context),
        backgroundColor: AppColors.accentOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tạo Tour', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _tours.isEmpty
          ? const Center(child: Text('Không có dữ liệu tour'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: _tours.length,
              itemBuilder: (ctx, i) => _buildTourCard(ctx, _tours[i]),
            ),
    );
  }

  Widget _buildTourCard(BuildContext context, Map<String, dynamic> tour) {
    final diffColors = {'easy': AppColors.success, 'moderate': AppColors.accentOrange, 'hard': AppColors.error};
    final diffLabels = {'easy': 'Dễ', 'moderate': 'Vừa', 'hard': 'Khó'};
    final diffColor = diffColors[tour['difficulty']] ?? AppColors.textLight;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      color: diffColor.withOpacity(0.1),
                      image: (tour['images'] as List?)?.isNotEmpty == true
                          ? DecorationImage(
                              image: NetworkImage((tour['images'] as List)[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (tour['images'] as List?)?.isEmpty == true
                        ? Center(child: Icon(Icons.terrain, size: 40, color: diffColor))
                        : null,
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: diffColor.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                      child: Text(diffLabels[tour['difficulty']] ?? 'Vừa', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule, size: 10, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(tour['duration'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(tour['name'] ?? 'Chưa đặt tên', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.star, size: 12, color: AppColors.accentGold),
                        Text(' ${tour['rating'] ?? 5.0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.group, size: 13, color: AppColors.textLight), const SizedBox(width: 4),
                    Text('Max ${tour['groupSize'] ?? 0} người', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                    const SizedBox(width: 12),
                    Icon(Icons.confirmation_number, size: 13, color: AppColors.textLight), const SizedBox(width: 4),
                    Text('${tour['bookings'] ?? 0} đã đặt', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Text('${_fmt(tour['price'] ?? 0)} ₫/người', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    _iconBtn(Icons.edit, AppColors.primaryBlue, () => _showTourForm(context, tour: tour)),
                    const SizedBox(width: 8),
                    _iconBtn(Icons.schedule, AppColors.accentOrange, () => _showScheduleEditor(context, tour)),
                    const SizedBox(width: 8),
                    _iconBtn(Icons.delete_outline, AppColors.error, () => _showDeleteConfirm(context, tour)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  String _fmt(int p) => p.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');

  void _showTourForm(BuildContext context, {Map<String, dynamic>? tour}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TourForm(
        tour: tour,
        onSubmit: (data, newImages, existingImages) async {
          final isEdit = tour != null;
          try {
            List<String> imageUrls = [...existingImages];
            
            if (newImages.isNotEmpty) {
              final newUrls = await StorageUtils.uploadMultipleFiles(newImages, 'tours');
              imageUrls.addAll(newUrls);
            }

            final tourData = {
              ...data,
              'images': imageUrls,
              'status': 'active',
              'rating': isEdit ? tour['rating'] : 5.0,
            };

            bool success;
            if (isEdit) {
              success = await _tourService.updateTour(tour['id'], tourData);
            } else {
              success = await _tourService.createTour(tourData);
            }

            if (success) {
              Navigator.pop(ctx);
              _fetchTours();
              _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã tạo tour');
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

  void _showScheduleEditor(BuildContext context, Map<String, dynamic> tour) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Text('Lịch trình — ${tour['name']}', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
          ])),
          const Divider(height: 1),
          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
            _scheduleTile('Ngày 1', 'Khởi hành', 'Đón khách tại điểm hẹn'),
            _scheduleTile('Ngày 1', 'Tham quan', 'Khám phá điểm đến chính'),
            _scheduleTile('Ngày 1', 'Trở về', 'Kết thúc hành trình'),
            const SizedBox(height: 16),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Thêm hoạt động'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48))),
          ])),
        ]),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, Map<String, dynamic> tour) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${tour['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _tourService.deleteTour(tour['id']);
              if (success) {
                _fetchTours();
                _showSuccessSnackbar('Đã xóa ${tour['name']}');
              } else {
                _showErrorSnackbar('Lỗi khi xóa tour');
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

  Widget _scheduleTile(String day, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(width: 50, padding: const EdgeInsets.symmetric(vertical: 6), decoration: BoxDecoration(color: AppColors.accentOrange, borderRadius: BorderRadius.circular(8)),
          child: Text(day, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
        ])),
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit, size: 18, color: AppColors.textLight)),
      ]),
    );
  }
}

class TourForm extends StatefulWidget {
  final Map<String, dynamic>? tour;
  final Future<bool> Function(Map<String, dynamic> data, List<File> newImages, List<String> existingImages) onSubmit;

  const TourForm({super.key, this.tour, required this.onSubmit});

  @override
  State<TourForm> createState() => _TourFormState();
}

class _TourFormState extends State<TourForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _groupSizeCtrl;
  late TextEditingController _durationCtrl;
  late TextEditingController _descCtrl;
  late String _difficulty;

  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;

  final List<String> _currencies = ['VND', 'USD', 'CNY'];
  String _selectedCurrency = 'VND';

  @override
  void initState() {
    super.initState();
    final t = widget.tour;
    final isEdit = t != null;
    _nameCtrl = TextEditingController(text: isEdit ? t['name'] : '');
    _priceCtrl = TextEditingController(text: isEdit ? t['price'].toString() : '');
    _groupSizeCtrl = TextEditingController(text: isEdit ? t['groupSize'].toString() : '');
    _durationCtrl = TextEditingController(text: isEdit ? t['duration'] : '');
    _descCtrl = TextEditingController(text: isEdit ? t['description'] ?? '' : '');
    _difficulty = isEdit ? t['difficulty'] : 'moderate';

    if (isEdit && t['images'] != null) {
      _existingImageUrls = List<String>.from(t['images']);
    }
    if (isEdit && t['currency'] != null) {
      _selectedCurrency = t['currency'];
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _groupSizeCtrl.dispose();
    _durationCtrl.dispose();
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
                  widget.tour != null ? 'Sửa Tour' : 'Tạo Tour mới',
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
                                color: AppColors.accentOrange.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.accentOrange.withOpacity(0.3)),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 32, color: AppColors.accentOrange),
                                  SizedBox(height: 4),
                                  Text('Thêm ảnh', style: TextStyle(color: AppColors.accentOrange, fontSize: 12)),
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
                      label: 'Tên tour *', 
                      controller: _nameCtrl, 
                      icon: Icons.tour,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tên tour' : null,
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
                            label: 'Nhóm tối đa *', 
                            controller: _groupSizeCtrl, 
                            icon: Icons.group,
                            isNumber: true,
                            validator: (v) {
                              if (v?.isEmpty == true) return 'Nhập số lượng';
                              if (int.tryParse(v!) == null) return 'Phải là số';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Thời lượng (vd: 8 tiếng, 2N1Đ) *', 
                      controller: _durationCtrl, 
                      icon: Icons.schedule,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập thời lượng' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Độ khó', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('🟢 Dễ'), 
                          selected: _difficulty == 'easy', 
                          onSelected: (s) { if(s) setState(() => _difficulty = 'easy'); },
                          selectedColor: AppColors.success.withOpacity(0.2),
                          backgroundColor: AppColors.backgroundLight,
                        ),
                        ChoiceChip(
                          label: const Text('🟡 Vừa'), 
                          selected: _difficulty == 'moderate', 
                          onSelected: (s) { if(s) setState(() => _difficulty = 'moderate'); },
                          selectedColor: AppColors.accentOrange.withOpacity(0.2),
                          backgroundColor: AppColors.backgroundLight,
                        ),
                        ChoiceChip(
                          label: const Text('🔴 Khó'), 
                          selected: _difficulty == 'hard', 
                          onSelected: (s) { if(s) setState(() => _difficulty = 'hard'); },
                          selectedColor: AppColors.error.withOpacity(0.2),
                          backgroundColor: AppColors.backgroundLight,
                        ),
                      ],
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
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: _isSubmitting 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(widget.tour != null ? 'Lưu thay đổi' : 'Tạo tour', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accentOrange, width: 1.5)),
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
        'groupSize': int.parse(_groupSizeCtrl.text),
        'duration': _durationCtrl.text.trim(),
        'difficulty': _difficulty,
        'description': _descCtrl.text.trim(),
      };

      await widget.onSubmit(data, _newImages, _existingImageUrls);
      
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}


