import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class ManageCruisesPage extends StatefulWidget {
  const ManageCruisesPage({super.key});
  @override
  State<ManageCruisesPage> createState() => _ManageCruisesPageState();
}

class _ManageCruisesPageState extends State<ManageCruisesPage> {
  final List<Map<String, dynamic>> _cruises = [
    {'name': 'Ambassador Cruise', 'route': 'Hạ Long - Bái Tử Long', 'duration': '2N1Đ', 'price': 4500000, 'rating': 4.9, 'cabins': 46, 'status': 'active'},
    {'name': 'Paradise Elegance', 'route': 'Vịnh Hạ Long', 'duration': '2N1Đ', 'price': 3800000, 'rating': 4.7, 'cabins': 31, 'status': 'active'},
    {'name': 'Stellar of the Seas', 'route': 'Hạ Long - Lan Hạ', 'duration': '3N2Đ', 'price': 6500000, 'rating': 4.8, 'cabins': 22, 'status': 'active'},
  ];

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
      body: ListView.builder(
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
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.cyan.shade400],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.sailing, size: 50, color: Colors.white38)),
                Positioned(top: 8, right: 8, child: _statusBadge(cruise['status'])),
                Positioned(bottom: 8, left: 12,
                  child: Text(cruise['duration'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
                    onPressed: () => _showItineraryEditor(context, cruise['name']),
                    icon: const Icon(Icons.map, size: 16), label: const Text('Lịch trình'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.accentOrange, side: const BorderSide(color: AppColors.accentOrange)),
                  )),
                  const SizedBox(width: 8),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, color: AppColors.error)),
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
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                    onTap: () {},
                    child: Container(
                      height: 140, decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3))),
                      child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.primaryBlue),
                        SizedBox(height: 6),
                        Text('Tải ảnh du thuyền', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
                      ])),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _formField('Tên du thuyền *', Icons.sailing, isEdit ? cruise['name'] : ''),
                  const SizedBox(height: 14),
                  _formField('Tuyến đường *', Icons.route, isEdit ? cruise['route'] : ''),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _formField('Giá/người (₫)', Icons.attach_money, isEdit ? cruise['price'].toString() : '', isNumber: true)),
                    const SizedBox(width: 12),
                    Expanded(child: _formField('Số cabin', Icons.door_back_door, isEdit ? cruise['cabins'].toString() : '', isNumber: true)),
                  ]),
                  const SizedBox(height: 14),
                  const Text('Thời gian', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: ['1 ngày', '2N1Đ', '3N2Đ'].map((d) => ChoiceChip(
                    label: Text(d), selected: false, onSelected: (_) {},
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
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: Text(isEdit ? 'Lưu thay đổi' : 'Thêm du thuyền', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  )),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField(String label, IconData icon, String initial, {bool isNumber = false}) {
    return TextField(
      controller: TextEditingController(text: initial),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }

  void _showItineraryEditor(BuildContext context, String name) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              Text('Lịch trình — $name', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
