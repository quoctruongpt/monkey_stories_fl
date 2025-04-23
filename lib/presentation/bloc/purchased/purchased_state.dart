part of 'purchased_cubit.dart';

class PurchasedState extends Equatable {
  const PurchasedState({
    this.products = const [],
    this.isInitialPurchased = false,
    this.isLoadingProducts = false,
    this.isGetProductsSuccess = false,
  });

  final List<PurchasedPackage> products;
  final bool isInitialPurchased;
  final bool isLoadingProducts;
  final bool isGetProductsSuccess;

  PurchasedState copyWith({
    List<PurchasedPackage>? products,
    bool? isInitialPurchased,
    bool? isLoadingProducts,
    bool? isGetProductsSuccess,
  }) {
    return PurchasedState(
      products: products ?? this.products,
      isInitialPurchased: isInitialPurchased ?? this.isInitialPurchased,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isGetProductsSuccess: isGetProductsSuccess ?? this.isGetProductsSuccess,
    );
  }

  Map<String, dynamic> toJson() {
    return {'products': products.map((e) => e.toJson()).toList()};
  }

  static PurchasedState fromJson(Map<String, dynamic> json) {
    try {
      final productListJson = json['products'] as List<dynamic>?;

      final List<PurchasedPackage> products =
          productListJson?.map((e) {
            return PurchasedPackage.fromJson(e as Map<String, dynamic>);
          }).toList() ??
          <PurchasedPackage>[];

      return PurchasedState(products: products);
    } catch (e, stackTrace) {
      logger.severe(
        'kkk Error parsing PurchasedState from JSON: $e\\n$stackTrace',
      );
      return const PurchasedState();
    }
  }

  @override
  List<Object?> get props => [
    products,
    isInitialPurchased,
    isLoadingProducts,
    isGetProductsSuccess,
  ];
}
