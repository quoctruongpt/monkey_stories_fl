import 'package:monkey_stories/data/datasources/kinesis/kinesis_remote_data_source.dart';
import 'package:monkey_stories/domain/entities/kinesis/kinesis_entity.dart';
import 'package:monkey_stories/domain/repositories/kinesis_repository.dart';

class KinesisRepositoryImpl extends KinesisRepository {
  final KinesisRemoteDataSource kinesisRemoteDataSource;

  KinesisRepositoryImpl({required this.kinesisRemoteDataSource});

  @override
  Future<KinesisEntity?> putSetting(
    String partitionKey,
    Map<String, dynamic> data,
  ) async {
    final result = await kinesisRemoteDataSource.pushSetting(
      partitionKey,
      data,
    );
    return result?.toEntity();
  }

  @override
  Future<KinesisEntity?> putRecordToKinesis(
    String streamName,
    String partitionKey,
    Map<String, dynamic> event,
  ) async {
    final result = await kinesisRemoteDataSource.putRecordToKinesis(
      streamName: streamName,
      partitionKey: partitionKey,
      event: event,
    );
    return result?.toEntity();
  }
}
