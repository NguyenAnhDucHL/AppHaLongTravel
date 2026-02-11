import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class ManageReviewsPage extends StatefulWidget {
  const ManageReviewsPage({super.key});
  @override
  State<ManageReviewsPage> createState() => _ManageReviewsPageState();
}

class _ManageReviewsPageState extends State<ManageReviewsPage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _reviews = [
    {'user': 'Nguyễn Văn A', 'item': 'Paradise Suites Hotel', 'type': 'hotel', 'rating': 5, 'text': 'Khách sạn tuyệt vời, view đẹp, dịch vụ tốt!', 'date': '10/02/2026', 'status': 'approved', 'photos': 2},
    {'user': 'Trần Thị B', 'item': 'Ambassador Cruise', 'type': 'cruise', 'rating': 4, 'text': 'Du thuyền sang trọng, đồ ăn ngon. Nhân viên nhiệt tình.', 'date': '09/02/2026', 'status': 'pending', 'photos': 3},
    {'user': '张三', 'item': 'Vịnh Hạ Long Full Day', 'type': 'tour', 'rating': 5, 'text': 'Beautiful scenery, amazing experience!', 'date': '08/02/2026', 'status': 'approved', 'photos': 5},
    {'user': 'Lê Minh Châu', 'item': 'Phương Nam Restaurant', 'type': 'restaurant', 'rating': 3, 'text': 'Đồ ăn tạm được, giá hơi cao.', 'date': '07/02/2026', 'status': 'pending', 'photos': 1},
    {'user': 'Phạm Đức', 'item': 'Novotel Ha Long', 'type': 'hotel', 'rating': 2, 'text': 'Phòng không sạch, nhân viên thái độ kém.', 'date': '06/02/2026', 'status': 'flagged', 'photos': 0},
    {'user': 'Mai Hương', 'item': 'Stellar of the Seas', 'type': 'cruise', 'rating': 5, 'text': 'Trải nghiệm hoàn hảo! Sẽ quay lại!', 'date': '05/02/2026', 'status': 'approved', 'photos': 4},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
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
        title: const Text('Quản lý Đánh giá'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primaryBlue,
          tabs: [
            Tab(text: 'Tất cả (${_reviews.length})'),
            Tab(text: 'Chờ (${_reviews.where((r) => r['status'] == 'pending').length})'),
            Tab(text: 'Duyệt (${_reviews.where((r) => r['status'] == 'approved').length})'),
            Tab(text: 'Báo cáo (${_reviews.where((r) => r['status'] == 'flagged').length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildList(_reviews),
          _buildList(_reviews.where((r) => r['status'] == 'pending').toList()),
          _buildList(_reviews.where((r) => r['status'] == 'approved').toList()),
          _buildList(_reviews.where((r) => r['status'] == 'flagged').toList()),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> reviews) {
    if (reviews.isEmpty) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.reviews, size: 48, color: AppColors.textLight),
        SizedBox(height: 8),
        Text('Không có đánh giá', style: TextStyle(color: AppColors.textLight)),
      ]));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: reviews.length,
      itemBuilder: (ctx, i) => _buildReviewCard(ctx, reviews[i]),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    final statusColors = {'approved': AppColors.success, 'pending': AppColors.accentOrange, 'flagged': AppColors.error};
    final statusLabels = {'approved': 'Đã duyệt', 'pending': 'Chờ duyệt', 'flagged': 'Bị báo cáo'};
    final typeIcons = {'hotel': Icons.hotel, 'cruise': Icons.sailing, 'tour': Icons.terrain, 'restaurant': Icons.restaurant};
    final statusColor = statusColors[review['status']] ?? AppColors.textLight;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // User info
          Row(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: Text((review['user'] as String).substring(0, 1), style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(review['user'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(children: [
                Icon(typeIcons[review['type']], size: 13, color: AppColors.textLight),
                const SizedBox(width: 4),
                Expanded(child: Text(review['item'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textLight), overflow: TextOverflow.ellipsis)),
              ]),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
              child: Text(statusLabels[review['status']]!, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          // Stars
          Row(children: [
            ...List.generate(5, (i) => Icon(
              i < (review['rating'] as int) ? Icons.star : Icons.star_border,
              size: 18, color: AppColors.accentGold,
            )),
            const Spacer(),
            Text(review['date'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
          ]),
          const SizedBox(height: 8),
          // Review text
          Text(review['text'] as String, style: const TextStyle(fontSize: 14, height: 1.4)),
          if ((review['photos'] as int) > 0) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.photo, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text('${review['photos']} ảnh đính kèm', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
            ]),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // Actions
          Row(children: [
            if (review['status'] == 'pending') ...[
              Expanded(child: _actionBtn(Icons.check, 'Duyệt', AppColors.success, () {})),
              const SizedBox(width: 8),
            ],
            if (review['status'] != 'flagged')
              Expanded(child: _actionBtn(Icons.flag, 'Báo cáo', AppColors.accentOrange, () {})),
            if (review['status'] == 'pending' || review['status'] != 'flagged')
              const SizedBox(width: 8),
            Expanded(child: _actionBtn(Icons.reply, 'Phản hồi', AppColors.primaryBlue, () => _showReplyDialog(context, review))),
            const SizedBox(width: 8),
            _iconBtn(Icons.delete_outline, AppColors.error, () {}),
          ]),
        ]),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: color), const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8),
    child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 18, color: color)),
  );

  void _showReplyDialog(BuildContext context, Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Phản hồi đánh giá của ${review['user']}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(10)),
            child: Text('"${review['text']}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(hintText: 'Nhập phản hồi...', filled: true, fillColor: AppColors.backgroundLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            child: const Text('Gửi phản hồi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
