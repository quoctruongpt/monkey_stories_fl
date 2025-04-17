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
}
