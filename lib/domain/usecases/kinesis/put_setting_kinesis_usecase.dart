import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/kinesis/kinesis_entity.dart';
import 'package:monkey_stories/domain/repositories/kinesis_repository.dart';

class PutSettingKinesisUsecase
    extends UseCase<KinesisEntity, PutSettingKinesisUsecaseParams> {
  final KinesisRepository kinesisRepository;

  PutSettingKinesisUsecase(this.kinesisRepository);

  @override
  Future<Either<ServerFailure, KinesisEntity>> call(
    PutSettingKinesisUsecaseParams params,
  ) async {
    try {
      final data = {
        'time_record': DateTime.now().microsecondsSinceEpoch,
        'event_name': params.eventName,
        'properties': params.data,
      };
      final result = await kinesisRepository.putSetting(
        params.partitionKey,
        data,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class PutSettingKinesisUsecaseParams {
  final String partitionKey;
  final String eventName;
  final Map<String, dynamic> data;

  PutSettingKinesisUsecaseParams({
    required this.partitionKey,
    required this.eventName,
    required this.data,
  });
}
