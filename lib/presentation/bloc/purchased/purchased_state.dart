part of 'purchased_cubit.dart';

class PurchasedState extends Equatable {
  const PurchasedState({
    this.products = const [],
    this.isInitialPurchased = false,
    this.isLoadingProducts = false,
    this.isGetProductsSuccess = false,
    this.isPurchasing = false,
    this.isVerifyPurchasedSuccess = false,
    this.purchasingItem,
    this.errorMessage,
    this.isNeedRegister = false,
  });

  // Danh sách thông tin sản phẩm
  final List<PurchasedPackage> products;

  // Đã kết nối thành công với store
  final bool isInitialPurchased;

  // Đang tải danh sách sản phẩm
  final bool isLoadingProducts;

  // Lấy danh sách sản phẩm thành công
  final bool isGetProductsSuccess;

  // Đang mua sản phẩm
  final bool isPurchasing;

  /// Mua sản phẩm thành công
  final bool isVerifyPurchasedSuccess;

  // Lỗi khi mua sản phẩm
  final String? errorMessage;

  // Thông tin sản phẩm đang mua
  final PurchasedPackage? purchasingItem;

  // Cần đi đăng ký sau khi mua thành công
  final bool isNeedRegister;

  PurchasedState copyWith({
    List<PurchasedPackage>? products,
    bool? isInitialPurchased,
    bool? isLoadingProducts,
    bool? isGetProductsSuccess,
    bool? isPurchasing,
    bool? isVerifyPurchasedSuccess,
    PurchasedPackage? purchasingItem,
    String? errorMessage,
    bool? isResetStatus,
    bool? isNeedRegister,
  }) {
    return PurchasedState(
      products: products ?? this.products,
      isInitialPurchased: isInitialPurchased ?? this.isInitialPurchased,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isGetProductsSuccess: isGetProductsSuccess ?? this.isGetProductsSuccess,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      isVerifyPurchasedSuccess:
          isResetStatus == true
              ? false
              : isVerifyPurchasedSuccess ?? this.isVerifyPurchasedSuccess,
      purchasingItem: purchasingItem ?? this.purchasingItem,
      errorMessage:
          isResetStatus == true ? null : errorMessage ?? this.errorMessage,
      isNeedRegister: isNeedRegister ?? this.isNeedRegister,
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
      return const PurchasedState();
    }
  }

  @override
  List<Object?> get props => [
    products,
    isInitialPurchased,
    isLoadingProducts,
    isGetProductsSuccess,
    isPurchasing,
    isVerifyPurchasedSuccess,
    purchasingItem,
    errorMessage,
    isNeedRegister,
  ];
}
