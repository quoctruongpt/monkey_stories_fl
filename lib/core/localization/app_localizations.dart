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

    _localizedStrings = jsonDecode(jsonString);
    return true;
  }

  String translate(String? key, {Map<String, String?>? params}) {
    if (key == null) return '';

    var translation = _localizedStrings[key]?.toString() ?? key;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation.replaceAll(
          '{{${paramKey}}}',
          paramValue ?? '',
        );
      });
    }

    return translation;
  }
}
