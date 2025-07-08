import 'dart:async'; // Import Stream

// Package imports:
import 'package:flutter_inapp_purchase/modules.dart';

// Project imports:
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class ListenToPurchaseErrorsUseCase {
  final PurchasedRepository repository;
  ListenToPurchaseErrorsUseCase(this.repository);

  Stream<PurchaseResult> call() {
    return repository.purchaseErrorStream;
  }
}
