import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/kinesis/kinesis_entity.dart';
import 'package:monkey_stories/domain/repositories/kinesis_repository.dart';

class PutRecordKinesisUsecase
    extends UseCase<KinesisEntity?, PutRecordKinesisUsecaseParams> {
  final KinesisRepository kinesisRepository;

  PutRecordKinesisUsecase(this.kinesisRepository);

  @override
  Future<Either<ServerFailure, KinesisEntity?>> call(
    PutRecordKinesisUsecaseParams params,
  ) async {
    try {
      final result = await kinesisRepository.putRecordToKinesis(
        params.streamName,
        params.partitionKey,
        params.data,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class PutRecordKinesisUsecaseParams {
  final String partitionKey;
  final String streamName;
  final Map<String, dynamic> data;

  PutRecordKinesisUsecaseParams({
    required this.partitionKey,
    required this.streamName,
    required this.data,
  });
}
