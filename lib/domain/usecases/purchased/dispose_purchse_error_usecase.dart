import 'package:monkey_stories/domain/repositories/purchased_repository.dart';

class DisposePurchasedUseCase {
  final PurchasedRepository repository;
  DisposePurchasedUseCase(this.repository);

  void call() {
    repository.dispose();
  }
}
