import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/data/datasources/purchased/purchased_remote_data_source.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';
import 'package:monkey_stories/domain/usecases/purchased/verify_purchased_usecase.dart';

class PurchasedRepositoryImpl extends PurchasedRepository {
  final PurchasedRemoteDataSource remoteDataSource;

  PurchasedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PurchasedPackage>> getProducts(List<PackageItem> packages) async {
    return await remoteDataSource.getProducts(packages);
  }

  @override
  Future<void> initialPurchased() async {
    return await remoteDataSource.initialPurchased();
  }

  @override
  Future<void> purchase(PurchasedPackage package) async {
    final String productId = package.id;
    final bool isSubscription = package.isSubscription;

    if (isSubscription) {
      await remoteDataSource.purchaseSubscription(productId);
    } else {
      await remoteDataSource.purchaseProduct(productId);
    }

    return;
  }

  @override
  Future<ApiResponse<Null>> verifyPurchase(VerifyPurchasedParams params) async {
    return await remoteDataSource.verifyPurchase(
      packageId: params.productId,
      receipt: params.transactionReceipt,
      price: params.price,
      currency: params.currency,
    );
  }

  @override
  Stream<PurchaseResult> get purchaseErrorStream =>
      remoteDataSource.purchaseErrorStream;

  @override
  Stream<PurchasedItemFlutter> get purchaseUpdatedStream =>
      remoteDataSource.purchaseUpdatedStream.map(
        (purchaseItem) => PurchasedItemFlutter(
          productId: purchaseItem.productId ?? '',
          transactionId: purchaseItem.transactionId ?? '',
          transactionDate: purchaseItem.transactionDate ?? DateTime.now(),
          transactionReceipt: purchaseItem.transactionReceipt ?? '',
          purchaseToken: purchaseItem.purchaseToken ?? '',
        ),
      );

  @override
  Future<void> restorePurchase() async {
    final result = await remoteDataSource.restorePurchase();

    if (result.isEmpty) {
      throw Exception('No purchase found');
    }

    for (var item in result) {
      final response = await remoteDataSource.verifyPurchase(
        packageId: item.productId ?? '',
        receipt: item.purchaseToken ?? '',
        price: 0,
        currency: '',
      );

      if (response.status == ApiStatus.fail) {
        throw Exception('Verify purchase failed');
      }
    }
    return;
  }

  @override
  void dispose() {
    remoteDataSource.dispose();
  }
}
