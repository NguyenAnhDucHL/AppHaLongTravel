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
      final transports = await _transportService.listAllVehicles();
      setState(() => _transports = transports);
      setState(() => _transports = transports);
    } catch (e) {
      print('ManageTransportPage Error: $e');
      _showErrorSnackbar('Lỗi tải dữ liệu: $e');
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
            SizedBox(
              height: 120,
              child: Stack(
                children: [
                   Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      color: Colors.indigo.withOpacity(0.1),
                      image: (t['images'] as List?)?.isNotEmpty == true
                          ? DecorationImage(
                              image: NetworkImage((t['images'] as List)[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (t['images'] as List?)?.isEmpty == true
                        ? const Center(child: Icon(Icons.directions_bus, size: 40, color: Colors.indigo))
                        : null,
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: (t['status'] == 'active' ? AppColors.success : AppColors.error).withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                      child: Text(t['status'] == 'active' ? 'Sẵn sàng' : 'Bảo trì', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                    Expanded(child: Text(t['name'] ?? 'Chưa đặt tên', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                     Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.star, size: 12, color: AppColors.accentGold),
                        Text(' ${t['rating'] ?? 5.0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(t['type'] ?? 'Bus', style: const TextStyle(color: Colors.indigo, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.airline_seat_recline_normal, size: 12, color: AppColors.textLight), const SizedBox(width: 2),
                    Text('${t['capacity'] ?? 0} chỗ', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                  ]),
                  const SizedBox(height: 8),
                   Row(children: [
                    Text('${_fmt(t['price'] ?? 0)} ₫', style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    _iconBtn(Icons.edit, AppColors.primaryBlue, () => _showTransportForm(context, t: t)),
                    const SizedBox(width: 8),
                    _iconBtn(Icons.delete_outline, AppColors.error, () => _showDeleteConfirm(context, t)),
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

  void _showTransportForm(BuildContext context, {Map<String, dynamic>? t}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TransportForm(
        transport: t,
        onSubmit: (data, newImages, existingImages) async {
          final isEdit = t != null;
          try {
            List<String> imageUrls = [...existingImages];
            
            if (newImages.isNotEmpty) {
              final newUrls = await StorageUtils.uploadMultipleFiles(newImages, 'transports');
              imageUrls.addAll(newUrls);
            }

            final transportData = {
              ...data,
              'images': imageUrls,
              'available': true,
              'status': 'active', // Keep just in case for UI
              'rating': isEdit ? t['rating'] : 5.0,
            };

            bool success;
            if (isEdit) {
              success = await _transportService.updateTransport(t['id'], transportData);
            } else {
              success = await _transportService.createTransport(transportData);
            }

            if (success) {
              Navigator.pop(ctx);
              _fetchTransports();
              _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã tạo mới');
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

class TransportForm extends StatefulWidget {
  final Map<String, dynamic>? transport;
  final Future<bool> Function(Map<String, dynamic> data, List<File> newImages, List<String> existingImages) onSubmit;

  const TransportForm({super.key, this.transport, required this.onSubmit});

  @override
  State<TransportForm> createState() => _TransportFormState();
}

class _TransportFormState extends State<TransportForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _capacityCtrl;
  late TextEditingController _routeCtrl;
  late TextEditingController _descCtrl;
  late String _type;
  
  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;

  final List<String> _currencies = ['VND', 'USD', 'CNY'];
  String _selectedCurrency = 'VND';

  @override
  void initState() {
    super.initState();
    final t = widget.transport;
    final isEdit = t != null;
    _nameCtrl = TextEditingController(text: isEdit ? t['name'] : '');
    _priceCtrl = TextEditingController(text: isEdit ? t['price'].toString() : '');
    _capacityCtrl = TextEditingController(text: isEdit ? t['capacity'].toString() : '');
    _routeCtrl = TextEditingController(text: isEdit ? t['route'] ?? '' : '');
    _descCtrl = TextEditingController(text: isEdit ? t['description'] ?? '' : '');
    _type = isEdit ? t['type'] : 'Bus';

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
    _capacityCtrl.dispose();
    _routeCtrl.dispose();
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
                  widget.transport != null ? 'Sửa Phương tiện' : 'Thêm Phương tiện',
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
                    const Text('Hình ảnh phương tiện', style: TextStyle(fontWeight: FontWeight.w600)),
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
                                color: Colors.indigo.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 32, color: Colors.indigo),
                                  SizedBox(height: 4),
                                  Text('Thêm ảnh', style: TextStyle(color: Colors.indigo, fontSize: 12)),
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
                      label: 'Tên phương tiện *', 
                      controller: _nameCtrl, 
                      icon: Icons.directions_bus,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tên' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
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
                              Container(
                                width: 80,
                                height: 56, // Match text field height
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCurrency,
                                    isExpanded: true,
                                    items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                                    onChanged: (v) { if(v != null) setState(() => _selectedCurrency = v); },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: 'Sức chứa *', 
                            controller: _capacityCtrl, 
                            icon: Icons.airline_seat_recline_normal,
                            isNumber: true,
                             validator: (v) {
                              if (v?.isEmpty == true) return 'Nhập sức chứa';
                              if (int.tryParse(v!) == null) return 'Phải là số';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Loại phương tiện', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: ['Bus', 'Limousine', 'Taxi', 'Private Car'].map((typ) {
                        final selected = _type == typ;
                        return ChoiceChip(
                          label: Text(typ, style: TextStyle(color: selected ? Colors.white : AppColors.textDark)),
                          selected: selected,
                          onSelected: (s) { if(s) setState(() => _type = typ); },
                          selectedColor: Colors.indigo,
                          backgroundColor: AppColors.backgroundLight,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Lịch trình/Tuyến đường', 
                      controller: _routeCtrl, 
                      icon: Icons.map,
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: _isSubmitting 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(widget.transport != null ? 'Lưu thay đổi' : 'Tạo mới', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
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
        'capacity': int.parse(_capacityCtrl.text),
        'type': _type,
        'route': _routeCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
      };

      await widget.onSubmit(data, _newImages, _existingImageUrls);
      
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
