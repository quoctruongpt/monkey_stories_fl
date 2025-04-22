import 'package:monkey_stories/domain/entities/kinesis/kinesis_entity.dart';

abstract class KinesisRepository {
  Future<KinesisEntity> putSetting(
    String partitionKey,
    Map<String, dynamic> data,
  );
  // Future<KinesisEntity> putEvent(
  //   String partitionKey,
  //   Map<String, dynamic> data,
  // );
}
