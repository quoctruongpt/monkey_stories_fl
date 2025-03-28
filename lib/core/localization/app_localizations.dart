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
    final List<String> keys = key.split('.');
    dynamic value = _localizedStrings;

    for (String k in keys) {
      value = value[k];
      if (value == null) return key;
    }

    return value.toString();
  }
}
