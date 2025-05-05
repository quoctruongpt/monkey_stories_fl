import 'package:flutter/widgets.dart';

class Language {
  final String code;
  final String name;
  final String localName;
  final String flag;
  final String description;
  final String shortName;
  const Language({
    required this.code,
    required this.name,
    required this.localName,
    required this.flag,
    required this.description,
    required this.shortName,
  });
}

class Languages {
  static String defaultLanguage = 'en';

  static const List<Language> supportedLanguages = [
    Language(
      flag: 'assets/images/flags/VN.png',
      description: 'Chọn ngôn ngữ hiển thị',
      code: 'vi',
      name: 'Vietnamese',
      shortName: 'VN',
      localName: 'Tiếng Việt',
    ),
    Language(
      flag: 'assets/images/flags/US.png',
      description: 'Select display language',
      code: 'en',
      name: 'English',
      shortName: 'EN',
      localName: 'English (US)',
    ),
    Language(
      flag: 'assets/images/flags/TH.png',
      description: 'nเลือกภาษาที่แสดง',
      code: 'th',
      name: 'Thai',
      shortName: 'TH',
      localName: 'ไทย',
    ),
    Language(
      flag: 'assets/images/flags/MC.png',
      description: 'Pilih bahasa paparan',
      code: 'ms',
      name: 'Malay',
      shortName: 'MS',
      localName: 'Malaysia',
    ),
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
