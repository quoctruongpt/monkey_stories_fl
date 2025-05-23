import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/notification_repository.dart';

class SaveFcmUsecase implements UseCase<void, NoParams> {
  final NotificationRepository _notificationRepository;

  SaveFcmUsecase({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await _notificationRepository.saveFcmToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
