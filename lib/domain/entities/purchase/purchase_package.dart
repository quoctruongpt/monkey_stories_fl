import 'package:monkey_stories/core/constants/purchase.dart';

class PurchasePackage extends PackageItem {
  final int price;
  final int originalPrice;
  final int priceForOneMonth;
  final String currency;
  final String priceDisplay;

  PurchasePackage({
    required this.price,
    required this.originalPrice,
    required this.priceForOneMonth,
    required this.currency,
    required this.priceDisplay,
    required super.id,
    required super.name,
    required super.saleOff,
    required super.type,
    required super.isSubscription,
  });
}
