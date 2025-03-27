class Orientation {
  static final String portrait = 'PORTRAIT';
  static final String landscapeLeft = 'LANDSCAPE-LEFT';
  static final String landscapeRight = 'LANDSCAPE-RIGHT';
}

enum AppOrientation {
  portrait('PORTRAIT'),
  landscapeLeft('LANDSCAPE-LEFT'),
  landscapeRight('LANDSCAPE-RIGHT');

  final String value;
  const AppOrientation(this.value);
}
