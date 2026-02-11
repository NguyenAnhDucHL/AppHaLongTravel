import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  // Mock payment cards data — International + Chinese + Vietnamese methods
  static final List<Map<String, dynamic>> _cards = [
    // International
    {
      'type': 'Visa',
      'last4': '4242',
      'expiry': '12/28',
      'isDefault': true,
      'gradient': AppColors.primaryGradient,
      'icon': Icons.credit_card,
    },
    // Vietnamese — MoMo
    {
      'type': 'MoMo',
      'last4': '0912',
      'expiry': '',
      'isDefault': false,
      'gradient': const [Color(0xFFAE2070), Color(0xFFD6368B)],
      'icon': Icons.phone_android,
    },
    // Vietnamese — VNPay
    {
      'type': 'VNPay',
      'last4': '0388',
      'expiry': '',
      'isDefault': false,
      'gradient': const [Color(0xFF005BAA), Color(0xFF0078D4)],
      'icon': Icons.qr_code,
    },
    // Vietnamese — ZaloPay
    {
      'type': 'ZaloPay',
      'last4': '0976',
      'expiry': '',
      'isDefault': false,
      'gradient': const [Color(0xFF008FE5), Color(0xFF00C1FF)],
      'icon': Icons.account_balance_wallet,
    },
    // Vietnamese — Bank Transfer
    {
      'type': 'bank_transfer',
      'last4': '6789',
      'expiry': '',
      'isDefault': false,
      'gradient': const [Color(0xFF1B5E20), Color(0xFF43A047)],
      'icon': Icons.account_balance,
      'displayName': 'Vietcombank',
    },
    // Chinese — WeChat Pay
    {
      'type': 'WeChat Pay',
      'last4': '8888',
      'expiry': '',
      'isDefault': false,
      'gradient': const [Color(0xFF07C160), Color(0xFF2DC84D)],
      'icon': Icons.chat_bubble,
    },
    // Chinese — Alipay
    {
      'type': 'Alipay',
      'last4': '6666',
      'expiry': '',
      'isDefault': false,
      'gradient': const [Color(0xFF1677FF), Color(0xFF00C2FF)],
      'icon': Icons.account_balance_wallet,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('payment_methods'.tr),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cards.isEmpty
                ? _buildEmptyState(context)
                : ListView(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    children: [
                      // Section: Vietnamese
                      _buildSectionHeader(context, 'payment_vn'.tr, '🇻🇳'),
                      ..._cards
                          .where((c) => ['MoMo', 'VNPay', 'ZaloPay', 'bank_transfer'].contains(c['type']))
                          .map((c) => _buildCardItem(context, c)),

                      const SizedBox(height: AppTheme.spacingM),

                      // Section: Chinese
                      _buildSectionHeader(context, 'payment_cn'.tr, '🇨🇳'),
                      ..._cards
                          .where((c) => ['WeChat Pay', 'Alipay'].contains(c['type']))
                          .map((c) => _buildCardItem(context, c)),

                      const SizedBox(height: AppTheme.spacingM),

                      // Section: International
                      _buildSectionHeader(context, 'payment_intl'.tr, '🌍'),
                      ..._cards
                          .where((c) => ['Visa', 'Mastercard'].contains(c['type']))
                          .map((c) => _buildCardItem(context, c)),
                    ],
                  ),
          ),
          // Add card button
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: Text('add_card'.tr),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String flag) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS, top: AppTheme.spacingS),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, Map<String, dynamic> card) {
    final displayName = card['displayName'] as String? ?? card['type'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        gradient: LinearGradient(
          colors: (card['gradient'] as List<Color>),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (card['gradient'] as List<Color>).first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      card['icon'] as IconData,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (card['isDefault'] as bool)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                      vertical: AppTheme.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Text(
                      'default_card'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              '•••• •••• •••• ${card['last4']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card['type'] as String,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if ((card['expiry'] as String).isNotEmpty)
                  Text(
                    '${'expires'.tr} ${card['expiry']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!(card['isDefault'] as bool))
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text('set_default'.tr, style: const TextStyle(fontSize: 12)),
                  ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text('delete'.tr, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_outlined,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'no_cards'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'no_cards_sub'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
