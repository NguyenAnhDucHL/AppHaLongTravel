import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/transport_service.dart';
import 'package:quang_ninh_travel/core/utils/storage_utils.dart';
import 'dart:io';

class ManageTransportPage extends StatefulWidget {
  const ManageTransportPage({super.key});
  @override
  State<ManageTransportPage> createState() => _ManageTransportPageState();
}

class _ManageTransportPageState extends State<ManageTransportPage> {
  final TransportService _transportService = Get.find<TransportService>();
  
  List<Map<String, dynamic>> _transports = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTransports();
  }

  Future<void> _fetchTransports() async {
    setState(() => _isLoading = true);
    try {
      final transports = await _transportService.listVehicles();
      setState(() => _transports = transports);
    } catch (e) {
      _showErrorSnackbar('Lỗi khi tải danh sách phương tiện');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Phương tiện')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTransportForm(context),
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Phương tiện', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _transports.isEmpty
          ? const Center(child: Text('Không có dữ liệu phương tiện'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: _transports.length,
              itemBuilder: (ctx, i) => _buildCard(ctx, _transports[i]),
            ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> t) {
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
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.directions_bus, size: 28, color: Colors.indigo),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t['name'] ?? '', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(t['type'] ?? 'Bus', style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.airline_seat_recline_normal, size: 13, color: AppColors.textLight), const SizedBox(width: 3),
                  Text('${t['capacity'] ?? 0} chỗ', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                ]),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star, size: 14, color: AppColors.accentGold), const SizedBox(width: 2),
                    Text('${t['rating'] ?? 5.0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ]),
                ),
                const SizedBox(height: 4),
                Text(t['status'] == 'active' ? 'Sẵn sàng' : 'Bảo trì', style: TextStyle(fontSize: 11, color: t['status'] == 'active' ? AppColors.success : AppColors.error)),
              ]),
            ]),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(children: [
              Text('${_fmt(t['price'] as int)} ₫', style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              _iconBtn(Icons.edit, AppColors.primaryBlue, () => _showTransportForm(context, t: t)),
              const SizedBox(width: 8),
              _iconBtn(Icons.delete_outline, AppColors.error, () => _showDeleteConfirm(context, t)),
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

  void _showTransportForm(BuildContext context, {Map<String, dynamic>? t}) {
    final isEdit = t != null;
    final nameCtrl = TextEditingController(text: isEdit ? t['name'] : '');
    final priceCtrl = TextEditingController(text: isEdit ? t['price'].toString() : '');
    final capacityCtrl = TextEditingController(text: isEdit ? t['capacity'].toString() : '');
    String type = isEdit ? t['type'] : 'Bus';

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
                const Text('Thêm/Sửa Phương tiện', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                          color: Colors.indigo.withOpacity(0.05), 
                          borderRadius: BorderRadius.circular(16), 
                          border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                          image: pickedFile != null ? DecorationImage(image: FileImage(pickedFile!), fit: BoxFit.cover) : null,
                        ),
                        child: pickedFile == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.add_photo_alternate, size: 36, color: Colors.indigo),
                          SizedBox(height: 6), Text('Tải ảnh phương tiện', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500)),
                        ])) : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _field('Tên phương tiện *', Icons.directions_bus, nameCtrl),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _field('Giá (₫)', Icons.attach_money, priceCtrl, isNumber: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('Sức chứa', Icons.airline_seat_recline_normal, capacityCtrl, isNumber: true)),
                    ]),
                    const SizedBox(height: 14),
                    const Text('Loại phương tiện', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: ['Bus', 'Limousine', 'Taxi', 'Private Car'].map((typ) => ChoiceChip(
                      label: Text(typ), 
                      selected: type == typ, 
                      onSelected: (s) { if(s) setSheetState(() => type = typ); },
                      selectedColor: Colors.indigo,
                      labelStyle: TextStyle(color: type == typ ? Colors.white : AppColors.textDark),
                    )).toList()),
                    const SizedBox(height: 14),
                    _field('Lịch trình/Tuyến đường', Icons.map, TextEditingController(text: isEdit ? t['route'] : '')),
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
                          if (pickedFile != null) imageUrl = await StorageUtils.uploadFile(pickedFile!, 'transports');

                          final data = {
                            'name': nameCtrl.text,
                            'price': int.tryParse(priceCtrl.text) ?? 0,
                            'capacity': int.tryParse(capacityCtrl.text) ?? 0,
                            'type': type,
                            'status': 'active',
                            'rating': isEdit ? t['rating'] : 5.0,
                            if (imageUrl != null) 'images': [imageUrl] else if (isEdit) 'images': t['images'] ?? [],
                          };

                          bool success;
                          if (isEdit) {
                            success = await _transportService.updateTransport(t['id'], data);
                          } else {
                            success = await _transportService.createTransport(data);
                          }

                          if (success) {
                            Navigator.pop(ctx);
                            _fetchTransports();
                            _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã tạo mới');
                          } else {
                            _showErrorSnackbar('Lỗi hệ thống');
                          }
                        } finally {
                          if (ctx.mounted) setSheetState(() => isSubmitting = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: isSubmitting 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isEdit ? 'Lưu thay đổi' : 'Tạo mới', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

  void _showDeleteConfirm(BuildContext context, Map<String, dynamic> t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${t['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _transportService.deleteTransport(t['id']);
              if (success) {
                _fetchTransports();
                _showSuccessSnackbar('Đã xóa ${t['name']}');
              } else {
                _showErrorSnackbar('Lỗi khi xóa');
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
