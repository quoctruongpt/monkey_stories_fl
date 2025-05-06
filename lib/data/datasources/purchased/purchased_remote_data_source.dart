import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/data/datasources/system/system_local_data_source.dart';
import 'package:monkey_stories/data/models/purchased/iap_item.dart';

// Định nghĩa Exception tùy chỉnh
class PurchaseException implements Exception {
  final String code;
  final String message;
  PurchaseException(this.code, this.message);

  @override
  String toString() => 'PurchaseException(code: $code, message: $message)';
}

abstract class PurchasedRemoteDataSource {
  Future<List<PurchasedPackage>> getProducts(List<PackageItem> packages);
  Future<void> initialPurchased();
  Future<PurchasedItem> purchaseSubscription(String packageId);
  Future<PurchasedItem> purchaseProduct(String packageId);
  Future<ApiResponse<Null>> verifyPurchase({
    required String packageId,
    required String receipt,
    required double price,
    required String currency,
  });
  Future<List<PurchasedItem>> restorePurchase();
  // Thêm getter cho stream lỗi
  Stream<PurchaseResult> get purchaseErrorStream;
  Stream<PurchasedItem> get purchaseUpdatedStream;
  // Thêm phương thức dọn dẹp
  void dispose();
}

class PurchasedRemoteDataSourceImpl extends PurchasedRemoteDataSource {
  final FlutterInappPurchase flutterInappPurchase;
  final SystemLocalDataSource systemLocalDataSource;
  final Dio dio;

  // StreamController để quản lý stream lỗi nội bộ
  final _purchaseErrorController = StreamController<PurchaseResult>.broadcast();
  final _purchaseUpdatedController =
      StreamController<PurchasedItem>.broadcast();
  // Subscription để lắng nghe từ thư viện
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _purchaseUpdatedSubscription;

  PurchasedRemoteDataSourceImpl({
    required this.flutterInappPurchase,
    required this.systemLocalDataSource,
    required this.dio,
  });

  // Getter trả về stream lỗi cho bên ngoài
  @override
  Stream<PurchaseResult> get purchaseErrorStream =>
      _purchaseErrorController.stream;

  @override
  Stream<PurchasedItem> get purchaseUpdatedStream =>
      _purchaseUpdatedController.stream;

  @override
  Future<List<PurchasedPackage>> getProducts(List<PackageItem> packages) async {
    final productIds =
        packages
            .where((element) => !element.isSubscription)
            .map((e) => e.id)
            .toList();
    final subscriptionIds =
        packages
            .where((element) => element.isSubscription)
            .map((e) => e.id)
            .toList();

    final products = await flutterInappPurchase.getProducts(productIds);
    final subscriptions = await flutterInappPurchase.getSubscriptions(
      subscriptionIds,
    );

    final productsMap = await Future.wait(
      products.map((e) => IAPItemFlutter(e, systemLocalDataSource).toEntity()),
    );
    final subscriptionsMap = await Future.wait(
      subscriptions.map(
        (e) => IAPItemFlutter(e, systemLocalDataSource).toEntity(),
      ),
    );

    return [...productsMap, ...subscriptionsMap];
  }

  // Khởi tạo việc mua hàng
  @override
  Future<void> initialPurchased() async {
    await flutterInappPurchase.initialize();
    // Bắt đầu lắng nghe lỗi bất đồng bộ khi khởi tạo
    _listenToPurchaseErrors();
    _listenToPurchaseUpdated();
  }

  void _listenToPurchaseErrors() {
    // Hủy lắng nghe cũ nếu có
    _purchaseErrorSubscription?.cancel();
    // Lắng nghe stream lỗi từ thư viện và đưa vào controller của chúng ta
    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((
      error,
    ) {
      if (!_purchaseErrorController.isClosed && error != null) {
        _purchaseErrorController.add(error);
      }
    });
  }

  void _listenToPurchaseUpdated() {
    // Hủy lắng nghe cũ nếu có
    _purchaseUpdatedSubscription?.cancel();
    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((
      item,
    ) {
      if (!_purchaseUpdatedController.isClosed && item != null) {
        print('kkk item: ${item.toString()}');
        _purchaseUpdatedController.add(item);
      }
    }, onError: (error) {});
  }

  // Mua hàng
  @override
  Future<PurchasedItem> purchaseSubscription(String packageId) async {
    try {
      final result = await flutterInappPurchase.requestSubscription(packageId);
      return result;
    } on PlatformException catch (e) {
      throw PurchaseException(e.code, e.message ?? 'Lỗi không xác định');
    } catch (e) {
      throw PurchaseException('UnknownError', e.toString());
    }
  }

  // Mua hàng
  @override
  Future<PurchasedItem> purchaseProduct(String packageId) async {
    try {
      // Thêm try-catch
      final result = await flutterInappPurchase.requestPurchase(packageId);
      return result;
    } on PlatformException catch (e) {
      throw PurchaseException(e.code, e.message ?? 'Lỗi không xác định');
    } catch (e) {
      throw PurchaseException('UnknownError', e.toString());
    }
  }

  // Xác thực mua hàng
  @override
  Future<ApiResponse<Null>> verifyPurchase({
    required String packageId,
    required String receipt,
    required double price,
    required String currency,
  }) async {
    final response = await dio.post(
      ApiEndpoints.verifyPurchase,
      data: {
        'package_id': packageId,
        'receipt': receipt,
        'price': price,
        'currency_code': currency,
      },
    );
    return ApiResponse.fromJson(response.data, (json, res) => null);
  }

  // Khôi phục mua hàng
  @override
  Future<List<PurchasedItem>> restorePurchase() async {
    final result = await flutterInappPurchase.getAvailablePurchases();
    return result ?? [];
  }

  // Phương thức dọn dẹp tài nguyên
  @override
  void dispose() {
    _purchaseErrorSubscription?.cancel();
    _purchaseErrorController.close();
    _purchaseUpdatedSubscription?.cancel();
    _purchaseUpdatedController.close();
  }
}
