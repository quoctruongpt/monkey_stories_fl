// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class SetUserUsecase implements UseCase<void, SetUserParams> {
  final TrackingRepository _trackingRepository;

  SetUserUsecase({required TrackingRepository trackingRepository})
    : _trackingRepository = trackingRepository;

  @override
  Future<Either<Failure, void>> call(SetUserParams params) async {
    _trackingRepository.setUserInfo(
      userId: params.userId,
      email: params.email,
      phone: params.phone,
      name: params.name,
      isPaid: params.isPaid,
      isAuthenticated: params.isAuthenticated,
    );
    return const Right(null);
  }
}

class SetUserParams {
  final String userId;
  final String? email;
  final String? phone;
  final String? name;
  final bool? isPaid;
  final bool? isAuthenticated;

  SetUserParams({
    required this.userId,
    this.email,
    this.phone,
    this.name,
    this.isPaid,
    this.isAuthenticated,
  });
}
