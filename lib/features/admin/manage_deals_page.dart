import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';

class ManageDealsPage extends StatefulWidget {
  const ManageDealsPage({super.key});
  @override
  State<ManageDealsPage> createState() => _ManageDealsPageState();
}

class _ManageDealsPageState extends State<ManageDealsPage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final _deals = [
    {'title': 'Giảm 30% Du thuyền Ambassador', 'type': 'cruise', 'discount': 30, 'valid': '28/02/2026', 'uses': 45, 'status': 'active'},
    {'title': 'Combo 2N1Đ Paradise Hotel', 'type': 'hotel', 'discount': 25, 'valid': '15/03/2026', 'uses': 120, 'status': 'active'},
    {'title': 'Miễn phí Kayak tour Bái Tử Long', 'type': 'tour', 'discount': 100, 'valid': '20/02/2026', 'uses': 30, 'status': 'active'},
    {'title': 'Flash Sale Hải sản Phương Nam', 'type': 'restaurant', 'discount': 20, 'valid': '12/02/2026', 'uses': 88, 'status': 'expired'},
  ];

  final _destinations = [
    {'name': 'Vịnh Hạ Long', 'desc': 'Di sản thiên nhiên thế giới', 'items': 15, 'views': 12500, 'featured': true},
    {'name': 'Bái Tử Long', 'desc': 'Vịnh hoang sơ tuyệt đẹp', 'items': 8, 'views': 6800, 'featured': true},
    {'name': 'Yên Tử', 'desc': 'Đất Phật thiêng liêng', 'items': 5, 'views': 8200, 'featured': true},
    {'name': 'Đảo Cô Tô', 'desc': 'Thiên đường đảo hoang', 'items': 6, 'views': 5400, 'featured': false},
    {'name': 'Móng Cái', 'desc': 'Thành phố biên giới sôi động', 'items': 4, 'views': 3200, 'featured': false},
    {'name': 'Đảo Quan Lạn', 'desc': 'Biển xanh cát trắng', 'items': 3, 'views': 4100, 'featured': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
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
        ListView.builder(
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
              _smallBtn(Icons.delete_outline, AppColors.error, () {}),
            ]),
          ]),
        ),
      ),
    );
  }

  void _showDealForm(BuildContext context, {Map<String, dynamic>? deal}) {
    final isEdit = deal != null;
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            GestureDetector(onTap: () {}, child: Container(
              height: 120, decoration: BoxDecoration(color: AppColors.accentCoral.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.accentCoral.withOpacity(0.3))),
              child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_photo_alternate, size: 32, color: AppColors.accentCoral),
                SizedBox(height: 4), Text('Ảnh banner ưu đãi', style: TextStyle(color: AppColors.accentCoral, fontWeight: FontWeight.w500, fontSize: 13)),
              ])),
            )),
            const SizedBox(height: 16),
            _field('Tiêu đề ưu đãi *', Icons.local_offer, isEdit ? deal['title'] : ''),
            const SizedBox(height: 14),
            const Text('Áp dụng cho', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              ChoiceChip(label: const Text('🏨 Khách sạn'), selected: false, onSelected: (_) {}),
              ChoiceChip(label: const Text('⛵ Du thuyền'), selected: false, onSelected: (_) {}),
              ChoiceChip(label: const Text('🏔 Tour'), selected: true, onSelected: (_) {}, selectedColor: AppColors.accentOrange),
              ChoiceChip(label: const Text('🍽 Nhà hàng'), selected: false, onSelected: (_) {}),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _field('Giảm giá (%)', Icons.percent, isEdit ? deal['discount'].toString() : '', isNumber: true)),
              const SizedBox(width: 12),
              Expanded(child: _field('Ngày hết hạn', Icons.calendar_today, isEdit ? deal['valid'] : '')),
            ]),
            const SizedBox(height: 14),
            _field('Mã ưu đãi (tùy chọn)', Icons.qr_code, ''),
            const SizedBox(height: 14),
            const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Điều kiện áp dụng...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCoral, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(isEdit ? 'Lưu thay đổi' : 'Tạo ưu đãi', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            )),
            const SizedBox(height: 24),
          ]))),
        ]),
      ),
    );
  }

  // ========= DESTINATIONS TAB =========
  Widget _buildDestinationsTab() {
    return Stack(
      children: [
        ListView.builder(
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
            const PopupMenuItem(child: Row(children: [Icon(Icons.edit, size: 18, color: AppColors.primaryBlue), SizedBox(width: 8), Text('Sửa')])),
            const PopupMenuItem(child: Row(children: [Icon(Icons.photo_library, size: 18, color: Colors.purple), SizedBox(width: 8), Text('Quản lý ảnh')])),
            const PopupMenuItem(child: Row(children: [Icon(Icons.delete, size: 18, color: AppColors.error), SizedBox(width: 8), Text('Xóa')])),
          ],
        ),
      ),
    );
  }

  void _showDestinationForm(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.8,
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Text('Thêm Điểm đến', style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
          ])),
          const Divider(height: 1),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(onTap: () {}, child: Container(
              height: 160, decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3))),
              child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_photo_alternate, size: 40, color: AppColors.primaryBlue),
                SizedBox(height: 6), Text('Ảnh bìa điểm đến', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
                Text('Nên dùng ảnh ngang 16:9', style: TextStyle(color: AppColors.textLight, fontSize: 11)),
              ])),
            )),
            const SizedBox(height: 16),
            _field('Tên điểm đến *', Icons.place, ''),
            const SizedBox(height: 14),
            _field('Mô tả ngắn', Icons.description, ''),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _field('Vĩ độ', Icons.my_location, '', isNumber: true)),
              const SizedBox(width: 12),
              Expanded(child: _field('Kinh độ', Icons.my_location, '', isNumber: true)),
            ]),
            const SizedBox(height: 14),
            SwitchListTile(
              value: false, onChanged: (_) {},
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
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Thêm điểm đến', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            )),
            const SizedBox(height: 24),
          ]))),
        ]),
      ),
    );
  }

  // Shared helpers
  Widget _smallBtn(IconData icon, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8),
    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: color)),
  );

  Widget _field(String label, IconData icon, String initial, {bool isNumber = false}) => TextField(
    controller: TextEditingController(text: initial),
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
  );
}
