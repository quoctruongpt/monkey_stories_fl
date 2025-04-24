import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/domain/repositories/purchased_repository.dart';
import 'dart:async';

class ListenToPurchaseUpdatesUseCase {
  final PurchasedRepository repository;
  ListenToPurchaseUpdatesUseCase(this.repository);

  Stream<PurchasedItemFlutter> call() {
    return repository.purchaseUpdatedStream;
  }
}
