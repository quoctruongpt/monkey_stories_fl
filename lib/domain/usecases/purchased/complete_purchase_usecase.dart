import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class CompletePurchaseUsecase {
  final PurchasedRepository repository;

  CompletePurchaseUsecase({required this.repository});

  Future<void> call(String transactionId) async {
    return await repository.completePurchase(transactionId);
  }
}
