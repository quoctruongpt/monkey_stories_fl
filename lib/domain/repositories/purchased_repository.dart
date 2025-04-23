import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';

abstract class PurchasedRepository {
  Future<List<PurchasedPackage>> getProducts(List<PackageItem> packages);
  Future<void> initialPurchased();
}
