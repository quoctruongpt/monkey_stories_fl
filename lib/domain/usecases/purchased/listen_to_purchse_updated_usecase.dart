// Dart imports:
import 'dart:async';

// Project imports:
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class ListenToPurchaseUpdatesUseCase {
  final PurchasedRepository repository;
  ListenToPurchaseUpdatesUseCase(this.repository);

  Stream<PurchasedItemFlutter> call() {
    return repository.purchaseUpdatedStream;
  }
}
