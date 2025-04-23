import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/data/datasources/system/system_local_data_source.dart';
import 'package:monkey_stories/data/models/purchased/iap_item.dart';

abstract class PurchasedRemoteDataSource {
  Future<List<PurchasedPackage>> getProducts(List<PackageItem> packages);
  Future<void> initialPurchased();
}

class PurchasedRemoteDataSourceImpl extends PurchasedRemoteDataSource {
  final FlutterInappPurchase flutterInappPurchase;
  final SystemLocalDataSource systemLocalDataSource;

  PurchasedRemoteDataSourceImpl({
    required this.flutterInappPurchase,
    required this.systemLocalDataSource,
  });

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

    print('products: $products');

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

  @override
  Future<void> initialPurchased() async {
    await flutterInappPurchase.initialize();
  }
}
