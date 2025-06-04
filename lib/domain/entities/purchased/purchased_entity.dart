import 'package:monkey_stories/core/constants/purchased.dart';

class PurchasedPackage extends PackageItem {
  final double price;
  final String localPrice;
  final String localOriginalPrice;
  final String localPriceForOneMonth;
  final double originalPrice;
  final double priceForOneMonth;
  final String currency;
  final String priceDisplay;
  final double appliedSaleOff;
  final bool canUseTrial;

  PurchasedPackage({
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
    required this.localPrice,
    required this.localOriginalPrice,
    required this.localPriceForOneMonth,
    required this.appliedSaleOff,
    required this.canUseTrial,
    required super.isBestSeller,
  });

  factory PurchasedPackage.fromJson(Map<String, dynamic> json) {
    return PurchasedPackage(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      originalPrice: json['originalPrice'],
      priceForOneMonth: json['priceForOneMonth'],
      currency: json['currency'],
      priceDisplay: json['priceDisplay'],
      appliedSaleOff: json['appliedSaleOff'],
      localPrice: json['localPrice'],
      localOriginalPrice: json['localOriginalPrice'],
      localPriceForOneMonth: json['localPriceForOneMonth'],
      saleOff: SaleOff.fromJson(json['saleOff']),
      type: PackageType.fromValue(json['type']),
      isSubscription: json['isSubscription'],
      canUseTrial: json['canUseTrial'],
      isBestSeller: json['isBestSeller'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'priceForOneMonth': priceForOneMonth,
      'currency': currency,
      'priceDisplay': priceDisplay,
      'appliedSaleOff': appliedSaleOff,
      'localPrice': localPrice,
      'localOriginalPrice': localOriginalPrice,
      'localPriceForOneMonth': localPriceForOneMonth,
      'saleOff': saleOff.toJson(),
      'type': type.value,
      'isSubscription': isSubscription,
      'canUseTrial': canUseTrial,
      'isBestSeller': isBestSeller,
    };
  }
}

class PurchasedItemFlutter {
  final String productId;
  final String transactionId;
  final DateTime transactionDate;
  final String transactionReceipt;
  final String purchaseToken;

  PurchasedItemFlutter({
    required this.productId,
    required this.transactionId,
    required this.transactionDate,
    required this.transactionReceipt,
    required this.purchaseToken,
  });
}
