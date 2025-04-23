import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/core/utils/number.dart';
import 'package:monkey_stories/data/datasources/system/system_local_data_source.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart'; // Import your entity

/// A wrapper around IAPItem to add conversion logic to the Domain Entity.
class IAPItemFlutter {
  final IAPItem item;
  final SystemLocalDataSource systemLocalDataSource;

  IAPItemFlutter(this.item, this.systemLocalDataSource);

  Future<PurchasedPackage> toEntity() async {
    final localPackage = Purchase.getPackageById(item.productId ?? '');
    final price = _parsePriceToDouble(item.localizedPrice ?? item.price);
    final priceForOneMonth = _getPriceForMonth(price, localPackage.type);
    final countryCode = await systemLocalDataSource.getCountryCode();
    final appliedSaleOff = localPackage.getSaleOff(countryCode);
    final originalPrice = price / (1 - appliedSaleOff);

    return PurchasedPackage(
      id: item.productId ?? '',
      name: localPackage.name, // Map title to name based on previous usage
      price: price,
      localPrice: formatCurrency(price, item.currency ?? ''),
      originalPrice: originalPrice,
      localOriginalPrice: formatCurrency(originalPrice, item.currency ?? ''),
      priceForOneMonth: priceForOneMonth,
      localPriceForOneMonth: formatCurrency(
        priceForOneMonth,
        item.currency ?? '',
      ),
      currency: item.currency ?? '',
      priceDisplay: item.localizedPrice ?? item.price ?? '',
      saleOff: localPackage.saleOff, // Provide a non-null default value
      type: localPackage.type, // Provide a non-null default value
      isSubscription: localPackage.isSubscription,
      appliedSaleOff: appliedSaleOff,
    );
  }

  double _getPriceForMonth(double price, PackageType type) {
    switch (type) {
      case PackageType.sixMonth:
        return price / 6;
      case PackageType.oneYear:
        return price / 12;
      default:
        return 0;
    }
  }

  static double _parsePriceToDouble(String? price) {
    if (price == null) return 0;

    // Loại bỏ ký tự không phải số hoặc dấu chấm/phẩy
    final cleaned = price.replaceAll(RegExp(r'[^\d.,]'), '');

    // Ưu tiên dấu `.` là phần thập phân
    final numeric = cleaned.replaceAll(',', '').replaceAll('.', '');

    try {
      return double.parse(numeric);
    } catch (_) {
      return 0;
    }
  }
}
