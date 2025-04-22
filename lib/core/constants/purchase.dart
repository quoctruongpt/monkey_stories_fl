enum PackageType { sixMonth, oneYear, lifetime }

class SaleOff {
  final int? vn;
  final int? us;
  final int? th;
  final int? ms;
  final int other;

  const SaleOff({this.vn, this.us, this.th, this.ms, required this.other});
}

class PackageItem {
  final String id;
  final String name;
  final SaleOff saleOff;
  final PackageType type;
  final bool isSubscription;

  const PackageItem({
    required this.id,
    required this.name,
    required this.saleOff,
    required this.type,
    required this.isSubscription,
  });
}

class Purchase {
  static const String sixMonthId = 'new.earlystart.stories.6month.promotion';
  static const String oneYearId = 'new.earlystart.stories.1year.promotion';
  static const String lifetimeId = 'new.earlystart.storie.lifetime.promotion';

  static const List<PackageItem> packages = [
    PackageItem(
      id: sixMonthId,
      name: '6 tháng',
      saleOff: SaleOff(vn: 40, other: 40),
      type: PackageType.sixMonth,
      isSubscription: true,
    ),
    PackageItem(
      id: oneYearId,
      name: '1 năm',
      saleOff: SaleOff(vn: 40, other: 40),
      type: PackageType.oneYear,
      isSubscription: true,
    ),
    PackageItem(
      id: lifetimeId,
      name: 'Trọn đời',
      saleOff: SaleOff(vn: 40, other: 40),
      type: PackageType.lifetime,
      isSubscription: false,
    ),
  ];

  static PackageItem recommendedPackage() {
    return packages.firstWhere(
      (element) => element.type == PackageType.oneYear,
    );
  }

  static PackageItem getPackageById(String id) {
    return packages.firstWhere((element) => element.id == id);
  }
}
