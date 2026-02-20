import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/admin_service.dart';
import 'package:quang_ninh_travel/core/utils/storage_utils.dart';
import 'dart:io';

class ManageDealsPage extends StatefulWidget {
  const ManageDealsPage({super.key});
  @override
  State<ManageDealsPage> createState() => _ManageDealsPageState();
}

class _ManageDealsPageState extends State<ManageDealsPage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final AdminService _adminService = Get.find<AdminService>();

  List<Map<String, dynamic>> _deals = [];
  List<Map<String, dynamic>> _destinations = [];
  bool _isLoadingDeals = false;
  bool _isLoadingDestinations = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _fetchDeals();
    _fetchDestinations();
  }

  Future<void> _fetchDeals() async {
    setState(() => _isLoadingDeals = true);
    try {
      final deals = await _adminService.listDeals();
      setState(() => _deals = deals);
    } finally {
      setState(() => _isLoadingDeals = false);
    }
  }

  Future<void> _fetchDestinations() async {
    setState(() => _isLoadingDestinations = true);
    try {
      final dests = await _adminService.listDestinations();
      setState(() => _destinations = dests);
    } finally {
      setState(() => _isLoadingDestinations = false);
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ưu đãi & Điểm đến'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(icon: Icon(Icons.local_offer), text: 'Ưu đãi nổi bật'),
            Tab(icon: Icon(Icons.place), text: 'Điểm đến phổ biến'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildDealsTab(),
          _buildDestinationsTab(),
        ],
      ),
    );
  }

  // ========= DEALS TAB =========
  Widget _buildDealsTab() {
    return Stack(
      children: [
        _isLoadingDeals
          ? const Center(child: CircularProgressIndicator())
          : _deals.isEmpty
            ? const Center(child: Text('Không có ưu đãi nào'))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: _deals.length,
                itemBuilder: (ctx, i) => _buildDealCard(ctx, _deals[i]),
              ),
        Positioned(
          bottom: 16, left: 16, right: 16,
          child: ElevatedButton.icon(
            onPressed: () => _showDealForm(context),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Tạo Ưu đãi mới', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDealCard(BuildContext context, Map<String, dynamic> deal) {
    final isExpired = deal['status'] == 'expired';
    final typeIcons = {'cruise': Icons.sailing, 'hotel': Icons.hotel, 'tour': Icons.terrain, 'restaurant': Icons.restaurant};
    final typeColors = {'cruise': Colors.blue, 'hotel': AppColors.primaryBlue, 'tour': AppColors.accentOrange, 'restaurant': AppColors.accentGold};

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isExpired
              ? null
              : LinearGradient(colors: [
                  (typeColors[deal['type']] ?? AppColors.primaryBlue).withOpacity(0.05),
                  Colors.white,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: (typeColors[deal['type']] ?? AppColors.primaryBlue).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(typeIcons[deal['type']], size: 24, color: typeColors[deal['type']]),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(deal['title'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isExpired ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(isExpired ? 'Hết hạn' : 'Đang chạy', style: TextStyle(color: isExpired ? AppColors.error : AppColors.success, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Text('HSD: ${deal['valid']}', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                ]),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('-${deal['discount']}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.people, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text('${deal['uses']} lượt sử dụng', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              const Spacer(),
              _smallBtn(Icons.edit, AppColors.primaryBlue, () => _showDealForm(context, deal: deal)),
              const SizedBox(width: 6),
              _smallBtn(Icons.delete_outline, AppColors.error, () => _showDeleteDealConfirm(context, deal)),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _buildDestinationsTab() {
    return Stack(
      children: [
        _isLoadingDestinations
          ? const Center(child: CircularProgressIndicator())
          : _destinations.isEmpty
            ? const Center(child: Text('Không có điểm đến nổi bật'))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: _destinations.length,
                itemBuilder: (ctx, i) => _buildDestinationCard(ctx, _destinations[i]),
              ),
        Positioned(
          bottom: 16, left: 16, right: 16,
          child: ElevatedButton.icon(
            onPressed: () => _showDestinationForm(context),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Thêm Điểm đến', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(BuildContext context, Map<String, dynamic> dest) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: (dest['images'] as List?)?.isNotEmpty == true
                ? DecorationImage(image: NetworkImage(dest['images'][0]), fit: BoxFit.cover)
                : null,
              color: AppColors.primaryBlue.withOpacity(0.1),
            ),
            child: (dest['images'] as List?)?.isEmpty == true
              ? const Center(child: Icon(Icons.place, size: 40, color: AppColors.primaryBlue))
              : null,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(dest['name'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                if (dest['featured'] == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.accentGold, borderRadius: BorderRadius.circular(4)),
                    child: const Text('Nổi bật', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ]),
              const SizedBox(height: 4),
              Text(dest['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 10),
              Row(children: [
                const Spacer(),
                _smallBtn(Icons.edit, AppColors.primaryBlue, () => _showDestinationForm(context, dest: dest)),
                const SizedBox(width: 6),
                _smallBtn(Icons.delete_outline, AppColors.error, () => _showDeleteDestinationConfirm(context, dest)),
              ]),
            ]),
          ),
        ],
      ),
    );
  }

  void _showDealForm(BuildContext context, {Map<String, dynamic>? deal}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DealForm(
        deal: deal,
        onSubmit: (data, newImages, existingImages) async {
          final isEdit = deal != null;
          try {
            List<String> imageUrls = [...existingImages];
            
            if (newImages.isNotEmpty) {
              final newUrls = await StorageUtils.uploadMultipleFiles(newImages, 'deals');
              imageUrls.addAll(newUrls);
            }

            final dealData = {
              ...data,
              'images': imageUrls,
              'status': 'active',
            };

            bool success;
            if (isEdit) {
              success = await _adminService.updateDeal(deal['id'], dealData);
            } else {
              success = await _adminService.createDeal(dealData);
            }

            if (success) {
              Navigator.pop(ctx);
              _fetchDeals();
              _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã tạo ưu đãi');
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

  void _showDestinationForm(BuildContext context, {Map<String, dynamic>? dest}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DestinationForm(
        destination: dest,
        onSubmit: (data, newImages, existingImages) async {
          final isEdit = dest != null;
          try {
            List<String> imageUrls = [...existingImages];
            
            if (newImages.isNotEmpty) {
              final newUrls = await StorageUtils.uploadMultipleFiles(newImages, 'destinations');
              imageUrls.addAll(newUrls);
            }

            final destData = {
              ...data,
              'images': imageUrls,
            };

            bool success;
            if (isEdit) {
              success = await _adminService.updateDestination(dest['id'], destData);
            } else {
              success = await _adminService.createDestination(destData);
            }

            if (success) {
              Navigator.pop(ctx);
              _fetchDestinations();
              _showSuccessSnackbar(isEdit ? 'Đã cập nhật' : 'Đã thêm điểm đến');
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

  // Shared helpers
  Widget _smallBtn(IconData icon, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8),
    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: color)),
  );

  void _showDeleteDealConfirm(BuildContext context, Map<String, dynamic> deal) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: Text('Bạn có chắc muốn xóa ưu đãi "${deal['title']}"?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            if (await _adminService.deleteDeal(deal['id'])) _fetchDeals();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Xóa', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  void _showDeleteDestinationConfirm(BuildContext context, Map<String, dynamic> dest) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: Text('Bạn có chắc muốn xóa điểm đến "${dest['name']}"?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx);
            if (await _adminService.deleteDestination(dest['id'])) _fetchDestinations();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Xóa', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  void _showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating));
  }
}

class DealForm extends StatefulWidget {
  final Map<String, dynamic>? deal;
  final Future<bool> Function(Map<String, dynamic> data, List<File> newImages, List<String> existingImages) onSubmit;

  const DealForm({super.key, this.deal, required this.onSubmit});

  @override
  State<DealForm> createState() => _DealFormState();
}

class _DealFormState extends State<DealForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _discountCtrl;
  late TextEditingController _validCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _descCtrl;
  late String _type;
  
  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final d = widget.deal;
    final isEdit = d != null;
    _titleCtrl = TextEditingController(text: isEdit ? d['title'] : '');
    _discountCtrl = TextEditingController(text: isEdit ? d['discount'].toString() : '');
    _validCtrl = TextEditingController(text: isEdit ? d['valid'] : '');
    _codeCtrl = TextEditingController(text: isEdit ? (d['code'] ?? '') : '');
    _descCtrl = TextEditingController(text: isEdit ? (d['description'] ?? '') : '');
    _type = isEdit ? d['type'] : 'cruise';

    if (isEdit && d['images'] != null) {
      _existingImageUrls = List<String>.from(d['images']);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _discountCtrl.dispose();
    _validCtrl.dispose();
    _codeCtrl.dispose();
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
                  widget.deal != null ? 'Sửa Ưu đãi' : 'Tạo Ưu đãi mới',
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
                    const Text('Hình ảnh banner', style: TextStyle(fontWeight: FontWeight.w600)),
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
                                color: AppColors.accentCoral.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.accentCoral.withOpacity(0.3)),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 32, color: AppColors.accentCoral),
                                  SizedBox(height: 4),
                                  Text('Thêm ảnh', style: TextStyle(color: AppColors.accentCoral, fontSize: 12)),
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
                      label: 'Tiêu đề ưu đãi *', 
                      controller: _titleCtrl, 
                      icon: Icons.local_offer,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tiêu đề' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Áp dụng cho', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['cruise', 'hotel', 'tour', 'restaurant'].map((t) => ChoiceChip(
                        label: Text(t.toUpperCase()), 
                        selected: _type == t, 
                        onSelected: (s) { if(s) setState(() => _type = t); },
                        selectedColor: AppColors.accentCoral,
                        backgroundColor: AppColors.backgroundLight,
                        labelStyle: TextStyle(color: _type == t ? Colors.white : AppColors.textDark),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Giảm giá (%) *', 
                            controller: _discountCtrl, 
                            icon: Icons.percent,
                            isNumber: true,
                            validator: (v) {
                              if (v?.isEmpty == true) return 'Nhập %';
                              if (int.tryParse(v!) == null) return 'Phải là số';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: 'Ngày hết hạn *', 
                            controller: _validCtrl, 
                            icon: Icons.calendar_today,
                            validator: (v) => v?.trim().isEmpty == true ? 'Nhập ngày' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Mã ưu đãi (tùy chọn)', 
                      controller: _codeCtrl, 
                      icon: Icons.qr_code,
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Điều kiện áp dụng...',
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
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCoral, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: _isSubmitting 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(widget.deal != null ? 'Lưu thay đổi' : 'Tạo ưu đãi', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accentCoral, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1)),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      final data = {
        'title': _titleCtrl.text.trim(),
        'type': _type,
        'discount': int.parse(_discountCtrl.text),
        'valid': _validCtrl.text.trim(),
        'code': _codeCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
      };

      await widget.onSubmit(data, _newImages, _existingImageUrls);
      
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class DestinationForm extends StatefulWidget {
  final Map<String, dynamic>? destination;
  final Future<bool> Function(Map<String, dynamic> data, List<File> newImages, List<String> existingImages) onSubmit;

  const DestinationForm({super.key, this.destination, required this.onSubmit});

  @override
  State<DestinationForm> createState() => _DestinationFormState();
}

class _DestinationFormState extends State<DestinationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _fullDescCtrl;
  bool _isFeatured = false;
  
  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final d = widget.destination;
    final isEdit = d != null;
    _nameCtrl = TextEditingController(text: isEdit ? d['name'] : '');
    _descCtrl = TextEditingController(text: isEdit ? d['desc'] : '');
    _fullDescCtrl = TextEditingController(text: isEdit ? (d['fullDescription'] ?? '') : '');
    _isFeatured = isEdit ? (d['featured'] == true) : false;

    if (isEdit && d['images'] != null) {
      _existingImageUrls = List<String>.from(d['images']);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _fullDescCtrl.dispose();
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
                  widget.destination != null ? 'Sửa Điểm đến' : 'Thêm Điểm đến',
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
                    const Text('Hình ảnh điểm đến', style: TextStyle(fontWeight: FontWeight.w600)),
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
                      label: 'Tên điểm đến *', 
                      controller: _nameCtrl, 
                      icon: Icons.place,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập tên điểm đến' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Mô tả ngắn *', 
                      controller: _descCtrl, 
                      icon: Icons.description,
                      validator: (v) => v?.trim().isEmpty == true ? 'Vui lòng nhập mô tả ngắn' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    SwitchListTile(
                      value: _isFeatured, 
                      onChanged: (v) => setState(() => _isFeatured = v),
                      title: const Text('Điểm đến nổi bật', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Hiển thị trên trang chủ', style: TextStyle(fontSize: 12)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: AppColors.backgroundLight,
                      activeColor: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Mô tả chi tiết', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _fullDescCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Giới thiệu về điểm đến...',
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
                          : Text(widget.destination != null ? 'Lưu thay đổi' : 'Thêm điểm đến', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
        'desc': _descCtrl.text.trim(),
        'fullDescription': _fullDescCtrl.text.trim(),
        'featured': _isFeatured,
      };

      await widget.onSubmit(data, _newImages, _existingImageUrls);
      
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

