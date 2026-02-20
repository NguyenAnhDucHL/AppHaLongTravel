import 'package:flutter/material.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/core/services/admin_service.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});
  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final AdminService _adminService = Get.find<AdminService>();

  List<Map<String, dynamic>> _users = [];
  int _totalUsers = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 5, vsync: this);
    _fetchUsers();
  }

  Future<void> _fetchUsers({String? role}) async {
    setState(() => _isLoading = true);
    try {
      final res = await _adminService.listUsers(role: role);
      setState(() {
        _users = List<Map<String, dynamic>>.from(res['data']);
        _totalUsers = res['total'] ?? 0;
      });
    } finally {
      setState(() => _isLoading = false);
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
        title: const Text('Quản lý Người dùng'),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: '👑 Admin'),
            Tab(text: '🤝 CTV'),
            Tab(text: '👤 KH'),
            Tab(text: '👻 Khách'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: List.generate(5, (index) => _buildUserList(_users)),
      ),
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (users.isEmpty) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.people_outline, size: 48, color: AppColors.textLight),
        SizedBox(height: 8),
        Text('Không có người dùng', style: TextStyle(color: AppColors.textLight)),
      ]));
    }
    return RefreshIndicator(
      onRefresh: () => _fetchUsers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: users.length,
        itemBuilder: (ctx, i) => _buildUserCard(ctx, users[i]),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user) {
    final roleInfo = _roleInfo(user['role'] as String? ?? 'guest');
    final isActive = user['isActive'] as bool? ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: roleInfo['color'].withOpacity(0.1),
                child: Text(
                  (user['name'] as String).substring(0, 1).toUpperCase(),
                  style: TextStyle(color: roleInfo['color'], fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(child: Text(user['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 6),
                  if (!isActive) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Bị chặn', style: TextStyle(fontSize: 9, color: AppColors.error, fontWeight: FontWeight.bold)),
                  ),
                ]),
                const SizedBox(height: 2),
                Text(user['email'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ])),
              // Role badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: (roleInfo['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(roleInfo['emoji'] as String, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 3),
                  Text(roleInfo['label'] as String, style: TextStyle(color: roleInfo['color'] as Color, fontSize: 10, fontWeight: FontWeight.w600)),
                ]),
              ),
            ]),

            // Assigned services for collaborators
            if (user['role'] == 'collaborator' && user['assignedServices'] != null) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, children: (user['assignedServices'] as List).map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(6)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.link, size: 12, color: AppColors.textLight),
                  const SizedBox(width: 3),
                  Text(s as String, style: const TextStyle(fontSize: 10, color: AppColors.textLight), overflow: TextOverflow.ellipsis),
                ]),
              )).toList()),
            ],

            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.phone, size: 12, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text((user['phone'] as String).isEmpty ? 'N/A' : user['phone'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              const SizedBox(width: 12),
              Icon(Icons.calendar_today, size: 12, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text(user['createdAt']?.toString().split('T')[0] ?? 'N/A', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              const Spacer(),
              // Actions
              _actionBtn(Icons.edit, AppColors.primaryBlue, () => _showRoleDialog(context, user)),
              const SizedBox(width: 6),
              if (user['role'] == 'collaborator')
                _actionBtn(Icons.link, Colors.purple, () => _showAssignDialog(context, user)),
              if (user['role'] == 'collaborator') const SizedBox(width: 6),
              _actionBtn(
                isActive ? Icons.block : Icons.check_circle,
                isActive ? AppColors.accentOrange : AppColors.success,
                () => _toggleActive(user),
              ),
              const SizedBox(width: 6),
              if (user['role'] != 'admin')
                _actionBtn(Icons.delete_outline, AppColors.error, () => _confirmDelete(context, user)),
            ]),
          ],
        ),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => UserRoleDialog(
        user: user,
        onRoleChanged: (success) {
          if (success) {
            _fetchUsers();
            _showSuccessSnackbar('Đã cập nhật vai trò cho ${user['name']}');
          }
        },
      ),
    );
  }

  void _showAssignDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AssignServicesDialog(
        user: user,
        onAssigned: (success) {
          if (success) {
            _fetchUsers();
            _showSuccessSnackbar('Đã cập nhật dịch vụ cho ${user['name']}');
          }
        },
      ),
    );
  }

  void _toggleActive(Map<String, dynamic> user) async {
    final isActive = user['isActive'] as bool? ?? true;
    final success = await _adminService.setUserActive(user['uid'] ?? user['id'], !isActive);
    if (success) {
      _fetchUsers();
      _showSuccessSnackbar(!isActive ? 'Đã mở khóa ${user['name']}' : 'Đã chặn ${user['name']}');
    } else {
      _showErrorSnackbar('Lỗi khi cập nhật trạng thái');
    }
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa tài khoản ${user['name']}? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _adminService.deleteUser(user['uid'] ?? user['id']);
              if (success) {
                _fetchUsers();
                _showSuccessSnackbar('Đã xóa ${user['name']}');
              } else {
                _showErrorSnackbar('Lỗi khi xóa người dùng');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8),
    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: color)),
  );

  Map<String, dynamic> _roleInfo(String role) {
    switch (role) {
      case 'admin':
        return {'label': 'Admin', 'emoji': '👑', 'color': const Color(0xFFE91E63)};
      case 'collaborator':
        return {'label': 'CTV', 'emoji': '🤝', 'color': Colors.purple};
      case 'customer':
        return {'label': 'Khách hàng', 'emoji': '👤', 'color': AppColors.primaryBlue};
      default:
        return {'label': 'Khách', 'emoji': '👻', 'color': AppColors.textLight};
    }
  }

  void _showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating));
  }
}

class UserRoleDialog extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(bool) onRoleChanged;

  const UserRoleDialog({super.key, required this.user, required this.onRoleChanged});

  @override
  State<UserRoleDialog> createState() => _UserRoleDialogState();
}

class _UserRoleDialogState extends State<UserRoleDialog> {
  final AdminService _adminService = Get.find<AdminService>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Đổi vai trò — ${widget.user['name']}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _roleOption('admin', '👑 Quản trị viên', 'Toàn quyền hệ thống'),
          _roleOption('collaborator', '🤝 Cộng tác viên', 'Quản lý dịch vụ được gán'),
          _roleOption('customer', '👤 Khách hàng', 'Đặt dịch vụ, viết đánh giá'),
          _roleOption('guest', '👻 Khách vãng lai', 'Chỉ xem thông tin'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
      ],
    );
  }

  Widget _roleOption(String role, String label, String desc) {
    final isSelected = widget.user['role'] == role;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: _isSubmitting ? null : () async {
          setState(() => _isSubmitting = true);
          try {
            final success = await _adminService.setUserRole(widget.user['uid'] ?? widget.user['id'], role);
            if (success) {
              Navigator.pop(context);
              widget.onRoleChanged(true);
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể đổi vai trò'), backgroundColor: AppColors.error));
              }
            }
          } finally {
            if (mounted) setState(() => _isSubmitting = false);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: AppColors.primaryBlue, width: 2) : null,
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
            ])),
            if (_isSubmitting && isSelected)
              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            else if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryBlue),
          ]),
        ),
      ),
    );
  }
}

class AssignServicesDialog extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(bool) onAssigned;

  const AssignServicesDialog({super.key, required this.user, required this.onAssigned});

  @override
  State<AssignServicesDialog> createState() => _AssignServicesDialogState();
}

class _AssignServicesDialogState extends State<AssignServicesDialog> {
  final AdminService _adminService = Get.find<AdminService>();
  // This would typically fetch services from backend
  final List<String> _allServices = ['Paradise Hotel', 'Novotel Ha Long', 'Ambassador Cruise', 'Stellar of the Seas', 'Hạ Long Full Day Tour', 'Yên Tử Trek', 'Nhà hàng Phương Nam'];
  late List<String> _assigned;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _assigned = List<String>.from((widget.user['assignedServices'] as List?) ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Gán dịch vụ — ${widget.user['name']}'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _allServices.map((s) => CheckboxListTile(
              value: _assigned.contains(s),
              onChanged: (v) {
                setState(() {
                  if (v!) {
                    _assigned.add(s);
                  } else {
                    _assigned.remove(s);
                  }
                });
              },
              title: Text(s, style: const TextStyle(fontSize: 14)),
              dense: true,
              activeColor: Colors.purple,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            )).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: _isSubmitting ? null : () async {
            setState(() => _isSubmitting = true);
            try {
              final success = await _adminService.setUserRole(
                widget.user['uid'] ?? widget.user['id'], 
                widget.user['role'], 
                assignedServices: _assigned
              );
              if (success) {
                Navigator.pop(context);
                widget.onAssigned(true);
              } else {
                 if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi khi gán dịch vụ'), backgroundColor: AppColors.error));
                }
              }
            } finally {
              if (mounted) setState(() => _isSubmitting = false);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          child: _isSubmitting 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Lưu', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
