import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/usecases/purchased/verify_purchased_usecase.dart';

abstract class PurchasedRepository {
  // Lấy thông tin các gói sản phẩm
  Future<List<PurchasedPackage>> getProducts(List<PackageItem> packages);
  // Khởi tạo việc mua hàng
  Future<void> initialPurchased();
  // Mua hàng
  Future<void> purchase(PurchasedPackage package);
  // Stream lỗi
  Stream<PurchaseResult> get purchaseErrorStream;
  // Stream cập nhật
  Stream<PurchasedItemFlutter> get purchaseUpdatedStream;
  // Xác thực mua hàng
  Future<ApiResponse<Null>> verifyPurchase(VerifyPurchasedParams params);
  // Khôi phục mua hàng
  Future<void> restorePurchase();
  // Dọn dẹp
  void dispose();

  // Hoàn tất mua hàng
  Future<void> completePurchase(String transactionId);
}
