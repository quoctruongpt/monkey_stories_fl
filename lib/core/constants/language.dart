import 'package:flutter/widgets.dart';

class Language {
  final String code;
  final String name;
  final String localName;

  const Language({
    required this.code,
    required this.name,
    required this.localName,
  });
}

class Languages {
  static String defaultLanguage = 'en';
  static const List<Language> supportedLanguages = [
    Language(code: 'en', name: 'English', localName: 'English'),
    Language(code: 'vi', name: 'Vietnamese', localName: 'Tiếng Việt'),
  ];

  static Language getLanguageByCode(String code) {
    return supportedLanguages.firstWhere(
      (language) => language.code == code,
      orElse: () => supportedLanguages.first,
    );
  }

  static List<Locale> getSupportedLocales() {
    return supportedLanguages.map((language) => Locale(language.code)).toList();
  }
}
