class ProfileUtil {
  static List<int> getNearYears() {
    final currentYear = DateTime.now().year;
    final years = List.generate(13, (index) => currentYear - index);

    return years;
  }
}
