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
            Row(children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [diffColor.withOpacity(0.2), diffColor.withOpacity(0.05)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.terrain, size: 28, color: diffColor),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tour['name'] as String, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: diffColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(diffLabels[tour['difficulty']]!, style: TextStyle(color: diffColor, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.schedule, size: 13, color: AppColors.textLight), const SizedBox(width: 3),
                  Text(tour['duration'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                  const SizedBox(width: 8),
                  Icon(Icons.group, size: 13, color: AppColors.textLight), const SizedBox(width: 3),
                  Text('Max ${tour['groupSize']}', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                ]),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star, size: 14, color: AppColors.accentGold), const SizedBox(width: 2),
                    Text('${tour['rating'] ?? 5.0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ]),
                ),
                const SizedBox(height: 4),
                Text('${tour['bookings']} đặt', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ]),
            ]),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(children: [
              Text('${_fmt(tour['price'] as int)} ₫/người', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 15)),
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
    final isEdit = tour != null;
    final nameCtrl = TextEditingController(text: isEdit ? tour['name'] : '');
    final priceCtrl = TextEditingController(text: isEdit ? tour['price'].toString() : '');
    final groupSizeCtrl = TextEditingController(text: isEdit ? tour['groupSize'].toString() : '');
    final durationCtrl = TextEditingController(text: isEdit ? tour['duration'] : '');
    String difficulty = isEdit ? tour['difficulty'] : 'moderate';

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
                Text(isEdit ? 'Sửa Tour' : 'Tạo Tour mới', style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
              ])),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GestureDetector(
                      onTap: () async {
                        final file = await StorageUtils.pickImage();
                        if (file != null) setSheetState(() => pickedFile = file);
                      },
                      child: Container(
                        height: 130, decoration: BoxDecoration(
                          color: AppColors.accentOrange.withOpacity(0.05), 
                          borderRadius: BorderRadius.circular(16), 
                          border: Border.all(color: AppColors.accentOrange.withOpacity(0.3)),
                          image: pickedFile != null ? DecorationImage(image: FileImage(pickedFile!), fit: BoxFit.cover) : null,
                        ),
                        child: pickedFile == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.add_photo_alternate, size: 36, color: AppColors.accentOrange),
                          SizedBox(height: 6), Text('Tải ảnh tour', style: TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.w500)),
                        ])) : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _field('Tên tour *', Icons.tour, nameCtrl),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _field('Giá/người (₫)', Icons.attach_money, priceCtrl, isNumber: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('Nhóm tối đa', Icons.group, groupSizeCtrl, isNumber: true)),
                    ]),
                    const SizedBox(height: 14),
                    _field('Thời lượng (vd: 8 tiếng, 2N1Đ)', Icons.schedule, durationCtrl),
                    const SizedBox(height: 14),
                    const Text('Độ khó', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: [
                      ChoiceChip(label: const Text('🟢 Dễ'), selected: difficulty == 'easy', onSelected: (s) { if(s) setSheetState(() => difficulty = 'easy'); }),
                      ChoiceChip(label: const Text('🟡 Vừa'), selected: difficulty == 'moderate', onSelected: (s) { if(s) setSheetState(() => difficulty = 'moderate'); }, selectedColor: AppColors.accentOrange),
                      ChoiceChip(label: const Text('🔴 Khó'), selected: difficulty == 'hard', onSelected: (s) { if(s) setSheetState(() => difficulty = 'hard'); }, selectedColor: AppColors.error),
                    ]),
                    const SizedBox(height: 14),
                    const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Nhập mô tả...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                    const SizedBox(height: 24),
                    SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                      onPressed: isSubmitting ? null : () async {
                        if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
                          _showErrorSnackbar('Vui lòng nhập đầy đủ thông tin');
                          return;
                        }
                        setSheetState(() => isSubmitting = true);
                        try {
                          String? imageUrl;
                          if (pickedFile != null) imageUrl = await StorageUtils.uploadFile(pickedFile!, 'tours');

                          final data = {
                            'name': nameCtrl.text,
                            'price': int.tryParse(priceCtrl.text) ?? 0,
                            'groupSize': int.tryParse(groupSizeCtrl.text) ?? 15,
                            'duration': durationCtrl.text,
                            'difficulty': difficulty,
                            'status': 'active',
                            'rating': isEdit ? tour['rating'] : 5.0,
                            if (imageUrl != null) 'images': [imageUrl] else if (isEdit) 'images': tour['images'] ?? [],
                          };

                          bool success;
                          if (isEdit) {
                            success = await _tourService.updateTour(tour['id'], data);
                          } else {
                            success = await _tourService.createTour(data);
                          }

                          if (success) {
                            Navigator.pop(ctx);
                            _fetchTours();
                            _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã tạo tour');
                          } else {
                            _showErrorSnackbar('Lỗi hệ thống');
                          }
                        } finally {
                          if (ctx.mounted) setSheetState(() => isSubmitting = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: isSubmitting 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isEdit ? 'Lưu thay đổi' : 'Tạo tour', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    )),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ]),
          );
        }
      ),
    );
  }

  Widget _field(String label, IconData icon, TextEditingController ctrl, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
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
