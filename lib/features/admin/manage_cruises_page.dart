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
                    Expanded(child: Text(cruise['name'], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                    _ratingBadge(cruise['rating']),
                  ],
                ),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.route, size: 14, color: AppColors.textLight), const SizedBox(width: 4),
                  Text(cruise['route'], style: Theme.of(context).textTheme.bodySmall),
                ]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _infoChip(Icons.door_back_door, '${cruise['cabins']} cabin'),
                    const Spacer(),
                    Text('${_fmt(cruise['price'])} ₫/người', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 15)),
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

  Widget _statusBadge(String s) => Container(
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
    final isEdit = cruise != null;
    final nameCtrl = TextEditingController(text: isEdit ? cruise['name'] : '');
    final routeCtrl = TextEditingController(text: isEdit ? cruise['route'] : '');
    final priceCtrl = TextEditingController(text: isEdit ? cruise['price'].toString() : '');
    final cabinsCtrl = TextEditingController(text: isEdit ? cruise['cabins'].toString() : '');
    String duration = isEdit ? cruise['duration'] : '2N1Đ';

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          bool isSubmitting = false;
          File? pickedFile;

          return Container(
            height: MediaQuery.of(ctx).size.height * 0.9,
            decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              children: [
                Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                  Text(isEdit ? 'Sửa Du thuyền' : 'Thêm Du thuyền', style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ])),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Image upload
                      GestureDetector(
                        onTap: () async {
                          final file = await StorageUtils.pickImage();
                          if (file != null) setSheetState(() => pickedFile = file);
                        },
                        child: Container(
                          height: 140, decoration: BoxDecoration(
                            color: Colors.blue.shade50, 
                            borderRadius: BorderRadius.circular(16), 
                            border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                            image: pickedFile != null ? DecorationImage(image: FileImage(pickedFile!), fit: BoxFit.cover) : null,
                          ),
                          child: pickedFile == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.primaryBlue),
                            SizedBox(height: 6),
                            Text('Tải ảnh du thuyền', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
                          ])) : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _formField('Tên du thuyền *', Icons.sailing, nameCtrl),
                      const SizedBox(height: 14),
                      _formField('Tuyến đường *', Icons.route, routeCtrl),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(child: _formField('Giá/người (₫)', Icons.attach_money, priceCtrl, isNumber: true)),
                        const SizedBox(width: 12),
                        Expanded(child: _formField('Số cabin', Icons.door_back_door, cabinsCtrl, isNumber: true)),
                      ]),
                      const SizedBox(height: 14),
                      const Text('Thời gian', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: ['1 ngày', '2N1Đ', '3N2Đ'].map((d) => ChoiceChip(
                        label: Text(d), selected: duration == d, 
                        onSelected: (s) { if (s) setSheetState(() => duration = d); },
                        selectedColor: AppColors.primaryBlue,
                        labelStyle: TextStyle(color: duration == d ? Colors.white : AppColors.textDark),
                      )).toList()),
                      const SizedBox(height: 14),
                      const Text('Bao gồm', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: ['Bữa ăn', 'Kayak', 'Vé hang', 'Hướng dẫn', 'Xe đưa đón'].map((s) => FilterChip(
                        label: Text(s, style: const TextStyle(fontSize: 12)), selected: true, onSelected: (_) {},
                        selectedColor: AppColors.primaryBlue, checkmarkColor: Colors.white,
                      )).toList()),
                      const SizedBox(height: 14),
                      const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Nhập mô tả...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                      const SizedBox(height: 24),
                      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                        onPressed: isSubmitting ? null : () async {
                          if (nameCtrl.text.isEmpty || routeCtrl.text.isEmpty) {
                            _showErrorSnackbar('Vui lòng nhập đầy đủ thông tin');
                            return;
                          }
                          setSheetState(() => isSubmitting = true);
                          try {
                            String? imageUrl;
                            if (pickedFile != null) imageUrl = await StorageUtils.uploadFile(pickedFile!, 'cruises');

                            final data = {
                              'name': nameCtrl.text,
                              'route': routeCtrl.text,
                              'price': int.tryParse(priceCtrl.text) ?? 0,
                              'cabins': int.tryParse(cabinsCtrl.text) ?? 0,
                              'duration': duration,
                              'status': 'active',
                              'rating': isEdit ? cruise['rating'] : 5.0,
                              if (imageUrl != null) 'images': [imageUrl] else if (isEdit) 'images': cruise['images'] ?? [],
                            };

                            bool success;
                            if (isEdit) {
                              success = await _cruiseService.updateCruise(cruise['id'], data);
                            } else {
                              success = await _cruiseService.createCruise(data);
                            }

                            if (success) {
                              Navigator.pop(ctx);
                              _fetchCruises();
                              _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã thêm thành công');
                            } else {
                              _showErrorSnackbar('Lỗi hệ thống');
                            }
                          } finally {
                            if (ctx.mounted) setSheetState(() => isSubmitting = false);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: isSubmitting 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(isEdit ? 'Lưu thay đổi' : 'Thêm du thuyền', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      )),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _formField(String label, IconData icon, TextEditingController ctrl, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
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
}
