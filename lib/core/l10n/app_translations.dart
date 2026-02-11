import 'package:get/get.dart';
import 'en_us.dart';
import 'vi_vn.dart';
import 'zh_cn.dart';

/// GetX Translations configuration
/// Supports: English, Vietnamese, Chinese (Simplified)
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'vi_VN': viVN,
    'zh_CN': zhCN,
  };
}
