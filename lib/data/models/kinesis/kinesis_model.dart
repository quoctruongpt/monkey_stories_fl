import 'package:aws_client/kinesis_2013_12_02.dart';
import 'package:monkey_stories/domain/entities/kinesis/kinesis_entity.dart';

class KinesisModel extends PutRecordOutput {
  KinesisModel({
    required super.sequenceNumber,
    required super.shardId,
    super.encryptionType,
  });

  KinesisEntity toEntity() {
    return KinesisEntity(sequenceNumber: sequenceNumber);
  }
}
