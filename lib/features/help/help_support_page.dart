import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('help_support'.tr),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: [
          // Quick Actions
          Row(
            children: [
              Expanded(child: _buildQuickAction(context, Icons.chat_bubble_outline, 'live_chat'.tr, AppColors.primaryBlue)),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(child: _buildQuickAction(context, Icons.phone_outlined, 'call_us'.tr, AppColors.success)),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(child: _buildQuickAction(context, Icons.email_outlined, 'email_us'.tr, AppColors.accentOrange)),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),

          // FAQs
          Text('faq'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppTheme.spacingM),
          _buildFaqItem(context, 'faq_booking'.tr, 'faq_booking_answer'.tr),
          _buildFaqItem(context, 'faq_cancel'.tr, 'faq_cancel_answer'.tr),
          _buildFaqItem(context, 'faq_payment'.tr, 'faq_payment_answer'.tr),
          _buildFaqItem(context, 'faq_refund'.tr, 'faq_refund_answer'.tr),
          _buildFaqItem(context, 'faq_contact'.tr, 'faq_contact_answer'.tr),

          const SizedBox(height: AppTheme.spacingL),

          // Contact Info
          Text('contact_info'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppTheme.spacingM),
          _buildContactTile(context, Icons.phone, '+84 (0)203 1234 567'),
          _buildContactTile(context, Icons.email, 'support@quangninhtravel.com'),
          _buildContactTile(context, Icons.location_on, 'contact_address'.tr),
          _buildContactTile(context, Icons.schedule, 'working_hours'.tr),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: ExpansionTile(
        title: Text(question, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppTheme.spacingM, 0, AppTheme.spacingM, AppTheme.spacingM),
            child: Text(answer, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMedium, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      contentPadding: EdgeInsets.zero,
    );
  }
}
