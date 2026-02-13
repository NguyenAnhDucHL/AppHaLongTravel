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

  void _showDealForm(BuildContext context, {Map<String, dynamic>? deal}) {
    final isEdit = deal != null;
    final titleCtrl = TextEditingController(text: isEdit ? deal['title'] : '');
    final discountCtrl = TextEditingController(text: isEdit ? deal['discount'].toString() : '');
    final validCtrl = TextEditingController(text: isEdit ? deal['valid'] : '');
    String type = isEdit ? deal['type'] : 'cruise';

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          bool isSubmitting = false;
          File? pickedFile;

          return Container(
            height: MediaQuery.of(ctx).size.height * 0.85,
            decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                Text(isEdit ? 'Sửa Ưu đãi' : 'Tạo Ưu đãi mới', style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
              ])),
              const Divider(height: 1),
              Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(onTap: () async {
                  final file = await StorageUtils.pickImage();
                  if (file != null) setSheetState(() => pickedFile = file);
                }, child: Container(
                  height: 120, decoration: BoxDecoration(
                    color: AppColors.accentCoral.withOpacity(0.05), 
                    borderRadius: BorderRadius.circular(16), 
                    border: Border.all(color: AppColors.accentCoral.withOpacity(0.3)),
                    image: pickedFile != null ? DecorationImage(image: FileImage(pickedFile!), fit: BoxFit.cover) : null,
                  ),
                  child: pickedFile == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add_photo_alternate, size: 32, color: AppColors.accentCoral),
                    SizedBox(height: 4), Text('Ảnh banner ưu đãi', style: TextStyle(color: AppColors.accentCoral, fontWeight: FontWeight.w500, fontSize: 13)),
                  ])) : null,
                )),
                const SizedBox(height: 16),
                _field('Tiêu đề ưu đãi *', Icons.local_offer, titleCtrl),
                const SizedBox(height: 14),
                const Text('Áp dụng cho', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: ['cruise', 'hotel', 'tour', 'restaurant'].map((t) => ChoiceChip(
                  label: Text(t.toUpperCase()), 
                  selected: type == t, 
                  onSelected: (s) { if(s) setSheetState(() => type = t); },
                  selectedColor: AppColors.accentCoral,
                  labelStyle: TextStyle(color: type == t ? Colors.white : AppColors.textDark),
                )).toList()),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _field('Giảm giá (%)', Icons.percent, discountCtrl, isNumber: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _field('Ngày hết hạn', Icons.calendar_today, validCtrl)),
                ]),
                const SizedBox(height: 14),
                _field('Mã ưu đãi (tùy chọn)', Icons.qr_code, TextEditingController()),
                const SizedBox(height: 14),
                const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Điều kiện áp dụng...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                  onPressed: isSubmitting ? null : () async {
                    if (titleCtrl.text.isEmpty || discountCtrl.text.isEmpty) {
                      _showErrorSnackbar('Vui lòng nhập đầy đủ thông tin');
                      return;
                    }
                    setSheetState(() => isSubmitting = true);
                    try {
                      String? imageUrl;
                      if (pickedFile != null) imageUrl = await StorageUtils.uploadFile(pickedFile!, 'deals');

                      final data = {
                        'title': titleCtrl.text,
                        'type': type,
                        'discount': int.tryParse(discountCtrl.text) ?? 0,
                        'valid': validCtrl.text,
                        'status': 'active',
                        if (imageUrl != null) 'images': [imageUrl] else if (isEdit) 'images': deal['images'] ?? [],
                      };

                      bool success;
                      if (isEdit) {
                        success = await _adminService.updateDeal(deal['id'], data);
                      } else {
                        success = await _adminService.createDeal(data);
                      }

                      if (success) {
                        Navigator.pop(ctx);
                        _fetchDeals();
                      }
                    } finally {
                      if (ctx.mounted) setSheetState(() => isSubmitting = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCoral, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: isSubmitting 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isEdit ? 'Lưu thay đổi' : 'Tạo ưu đãi', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                )),
                const SizedBox(height: 24),
              ]))),
            ]),
          );
        }
      ),
    );
  }

  // ========= DESTINATIONS TAB =========
  Widget _buildDestinationsTab() {
    return Stack(
      children: [
        _isLoadingDestinations
          ? const Center(child: CircularProgressIndicator())
          : _destinations.isEmpty
            ? const Center(child: Text('Không có điểm đến nào'))
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
    final isFeatured = dest['featured'] == true;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primaryBlue.withOpacity(0.2), AppColors.primaryLight.withOpacity(0.1)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.place, color: AppColors.primaryBlue, size: 28),
        ),
        title: Row(children: [
          Text(dest['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (isFeatured) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
              child: const Text('⭐ Nổi bật', style: TextStyle(fontSize: 9, color: AppColors.accentGold, fontWeight: FontWeight.bold)),
            ),
          ],
        ]),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dest['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.inventory_2, size: 12, color: AppColors.textLight), const SizedBox(width: 3),
            Text('${dest['items']} dịch vụ', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
            const SizedBox(width: 12),
            const Icon(Icons.visibility, size: 12, color: AppColors.textLight), const SizedBox(width: 3),
            Text('${dest['views']} lượt xem', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
          ]),
        ]),
        trailing: PopupMenuButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (_) => [
            PopupMenuItem(child: Row(children: [Icon(isFeatured ? Icons.star_border : Icons.star, size: 18, color: AppColors.accentGold), const SizedBox(width: 8), Text(isFeatured ? 'Bỏ nổi bật' : 'Đặt nổi bật')])),
            PopupMenuItem(onTap: () => _showDestinationForm(context, dest: dest), child: const Row(children: [Icon(Icons.edit, size: 18, color: AppColors.primaryBlue), SizedBox(width: 8), Text('Sửa')])),
            const PopupMenuItem(child: Row(children: [Icon(Icons.photo_library, size: 18, color: Colors.purple), SizedBox(width: 8), Text('Quản lý ảnh')])),
            PopupMenuItem(onTap: () => _showDeleteDestinationConfirm(context, dest), child: const Row(children: [Icon(Icons.delete, size: 18, color: AppColors.error), SizedBox(width: 8), Text('Xóa')])),
          ],
        ),
      ),
    );
  }

  void _showDestinationForm(BuildContext context, {Map<String, dynamic>? dest}) {
    final isEdit = dest != null;
    final nameCtrl = TextEditingController(text: isEdit ? dest['name'] : '');
    final descCtrl = TextEditingController(text: isEdit ? dest['desc'] : '');
    bool isFeatured = isEdit ? (dest['featured'] == true) : false;

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          bool isSubmitting = false;
          File? pickedFile;

          return Container(
            height: MediaQuery.of(ctx).size.height * 0.8,
            decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                Text(isEdit ? 'Sửa Điểm đến' : 'Thêm Điểm đến', style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
              ])),
              const Divider(height: 1),
              Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(onTap: () async {
                  final file = await StorageUtils.pickImage();
                  if (file != null) setSheetState(() => pickedFile = file);
                }, child: Container(
                  height: 160, decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.05), 
                    borderRadius: BorderRadius.circular(16), 
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                    image: pickedFile != null ? DecorationImage(image: FileImage(pickedFile!), fit: BoxFit.cover) : null,
                  ),
                  child: pickedFile == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add_photo_alternate, size: 40, color: AppColors.primaryBlue),
                    SizedBox(height: 6), Text('Ảnh bìa điểm đến', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
                    Text('Nên dùng ảnh ngang 16:9', style: TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ])) : null,
                )),
                const SizedBox(height: 16),
                _field('Tên điểm đến *', Icons.place, nameCtrl),
                const SizedBox(height: 14),
                _field('Mô tả ngắn', Icons.description, descCtrl),
                const SizedBox(height: 14),
                SwitchListTile(
                  value: isFeatured, 
                  onChanged: (v) => setSheetState(() => isFeatured = v),
                  title: const Text('Điểm đến nổi bật', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Hiển thị trên trang chủ', style: TextStyle(fontSize: 12)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: AppColors.backgroundLight,
                ),
                const SizedBox(height: 14),
                const Text('Mô tả chi tiết', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(maxLines: 4, decoration: InputDecoration(hintText: 'Giới thiệu về điểm đến...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                  onPressed: isSubmitting ? null : () async {
                    if (nameCtrl.text.isEmpty) {
                      _showErrorSnackbar('Vui lòng nhập tên điểm đến');
                      return;
                    }
                    setSheetState(() => isSubmitting = true);
                    try {
                      String? imageUrl;
                      if (pickedFile != null) imageUrl = await StorageUtils.uploadFile(pickedFile!, 'destinations');

                      final data = {
                        'name': nameCtrl.text,
                        'desc': descCtrl.text,
                        'featured': isFeatured,
                        if (imageUrl != null) 'images': [imageUrl] else if (isEdit) 'images': dest['images'] ?? [],
                      };

                      bool success;
                      if (isEdit) {
                        success = await _adminService.updateDestination(dest['id'], data);
                      } else {
                        success = await _adminService.createDestination(data);
                      }

                      if (success) {
                        Navigator.pop(ctx);
                        _fetchDestinations();
                      }
                    } finally {
                      if (ctx.mounted) setSheetState(() => isSubmitting = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: isSubmitting 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isEdit ? 'Lưu thay đổi' : 'Thêm điểm đến', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                )),
                const SizedBox(height: 24),
              ]))),
            ]),
          );
        }
      ),
    );
  }

  // Shared helpers
  Widget _smallBtn(IconData icon, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8),
    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: color)),
  );

  Widget _field(String label, IconData icon, TextEditingController ctrl, {bool isNumber = false}) => TextField(
    controller: ctrl,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
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

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating));
  }
}
