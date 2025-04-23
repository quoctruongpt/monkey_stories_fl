enum PackageType {
  oneMonth('1month'),
  sixMonth('6months'),
  oneYear('1year'),
  lifetime('lifetime');

  final String value;

  const PackageType(this.value);

  static PackageType fromValue(String value) {
    return PackageType.values.firstWhere((element) => element.value == value);
  }
}

class SaleOff {
  final double? vn;
  final double? us;
  final double? th;
  final double? ms;
  final double other;

  const SaleOff({this.vn, this.us, this.th, this.ms, required this.other});

  Map<String, double> toJson() {
    return {
      'vn': vn ?? other,
      'us': us ?? other,
      'th': th ?? other,
      'ms': ms ?? other,
      'other': other,
    };
  }

  static SaleOff fromJson(Map<String, dynamic> json) {
    double? _parseDouble(dynamic value) {
      if (value is double) {
        return value;
      }
      if (value is int) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    return SaleOff(
      vn: _parseDouble(json['vn']),
      us: _parseDouble(json['us']),
      th: _parseDouble(json['th']),
      ms: _parseDouble(json['ms']),
      other: _parseDouble(json['other']) ?? 0.0,
    );
  }
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

  double getSaleOff(String countryCode) {
    switch (countryCode.toLowerCase()) {
      case 'vn':
        return saleOff.vn ?? saleOff.other;
      case 'us':
        return saleOff.us ?? saleOff.other;
      case 'th':
        return saleOff.th ?? saleOff.other;
      case 'ms':
        return saleOff.ms ?? saleOff.other;
      default:
        return saleOff.other;
    }
  }
}

class Purchase {
  static const String sixMonthId = 'new.earlystart.stories.6month.promotion';
  static const String oneYearId = 'new.earlystart.stories.1year.promotion';
  static const String lifetimeId = 'new.earlystart.storie.lifetime.promotion';

  static const List<PackageItem> packages = [
    PackageItem(
      id: sixMonthId,
      name: '6 tháng',
      saleOff: SaleOff(vn: 0.4, other: 0.4),
      type: PackageType.sixMonth,
      isSubscription: true,
    ),
    PackageItem(
      id: oneYearId,
      name: '1 năm',
      saleOff: SaleOff(vn: 0.4, other: 0.4),
      type: PackageType.oneYear,
      isSubscription: true,
    ),
    PackageItem(
      id: lifetimeId,
      name: 'Trọn đời',
      saleOff: SaleOff(vn: 0.4, other: 0.4),
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
