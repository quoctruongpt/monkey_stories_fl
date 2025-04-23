import 'package:monkey_stories/core/constants/purchased.dart';
import 'package:monkey_stories/data/datasources/purchased/purchased_remote_data_source.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

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
}
