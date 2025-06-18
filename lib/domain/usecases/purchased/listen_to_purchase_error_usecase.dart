import 'package:flutter_inapp_purchase/modules.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';
import 'dart:async'; // Import Stream

class ListenToPurchaseErrorsUseCase {
  final PurchasedRepository repository;
  ListenToPurchaseErrorsUseCase(this.repository);

  Stream<PurchaseResult> call() {
    return repository.purchaseErrorStream;
  }
}
