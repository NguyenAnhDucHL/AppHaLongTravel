import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_long_travel/app/themes/app_colors.dart';
import 'package:ha_long_travel/app/themes/app_theme.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({super.key});

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  final _aspects = {
    'cleanliness': 0,
    'service': 0,
    'location': 0,
    'value': 0,
  };

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('write_review'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: const Icon(Icons.hotel, color: AppColors.primaryBlue),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Text('Hotel Paradise Premium', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Overall Rating
            Text('overall_rating'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 48,
                        color: i < _rating ? AppColors.accentGold : AppColors.textLight,
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (_rating > 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _getRatingLabel(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.accentGold, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            const SizedBox(height: AppTheme.spacingL),

            // Aspect Ratings
            Text('rate_aspects'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            ..._aspects.entries.map((e) => _buildAspectRow(context, e.key)),
            const SizedBox(height: AppTheme.spacingL),

            // Review Text
            Text('your_review'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingM),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'review_hint'.tr,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                filled: true,
                fillColor: AppColors.backgroundLight,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Photos
            Text('add_photos'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppTheme.spacingS),
            Row(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryBlue, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: const Icon(Icons.add_a_photo, color: AppColors.primaryBlue),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _rating > 0 ? () {
                  Get.back();
                  Get.snackbar('review_submitted'.tr, 'review_thanks'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.success,
                    colorText: Colors.white,
                  );
                } : null,
                child: Text('submit_review'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel() {
    switch (_rating) {
      case 1: return 'rating_terrible'.tr;
      case 2: return 'rating_poor'.tr;
      case 3: return 'rating_average'.tr;
      case 4: return 'rating_good'.tr;
      case 5: return 'rating_excellent'.tr;
      default: return '';
    }
  }

  Widget _buildAspectRow(BuildContext context, String aspect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(aspect.tr, style: Theme.of(context).textTheme.bodyMedium)),
          Expanded(
            child: Row(
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _aspects[aspect] = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      i < (_aspects[aspect] ?? 0) ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 28,
                      color: i < (_aspects[aspect] ?? 0) ? AppColors.accentGold : AppColors.textLight,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
