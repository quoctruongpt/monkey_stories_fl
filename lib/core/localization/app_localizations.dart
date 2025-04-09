import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    // Đọc file JSON từ assets
    final String jsonString = await rootBundle.loadString(
      'assets/translations/${locale.languageCode}.json',
    );

    _localizedStrings = json.decode(jsonString);
    return true;
  }

  String translate(String key) {
    // Kiểm tra trực tiếp xem key có tồn tại trong map không
    if (_localizedStrings.containsKey(key)) {
      // Nếu có, trả về giá trị tương ứng
      return _localizedStrings[key].toString();
    } else {
      // Nếu không tìm thấy, trả về key gốc (fallback)
      return key;
    }
  }
}
