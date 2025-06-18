import 'package:monkey_stories/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageUtils {
  static Future<String> getLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    // Giả sử bạn lưu mã ngôn ngữ với key 'language_code'
    final languageCode =
        prefs.getString('language_code') ??
        Languages.defaultLanguage; // Mặc định là 'en' nếu không tìm thấy

    switch (languageCode) {
      case 'vi':
        return 'vi-VN';
      case 'en':
        return 'en-US';
      case 'ms':
        return 'ms-MY';
      case 'th':
        return 'th-TH';
      default:
        // Trả về mặc định nếu mã ngôn ngữ không nằm trong danh sách hỗ trợ
        return 'en-US';
    }
  }

  static Future<String> getCountryFcm() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode =
        prefs.getString('language_code') ??
        Languages.defaultLanguage; // Mặc định là 'en' nếu không tìm thấy

    switch (languageCode) {
      case 'vi':
        return 'VN';
      case 'th':
        return 'TH';
      case 'ms':
        return 'MY';
      case 'id':
        return 'ID';
      default:
        return 'US';
    }
  }
}
