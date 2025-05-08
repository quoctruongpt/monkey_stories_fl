import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_client/kinesis_2013_12_02.dart';
import 'package:monkey_stories/core/constants/kinesis.dart';
import 'package:monkey_stories/data/models/kinesis/kinesis_model.dart';

abstract class KinesisRemoteDataSource {
  Future<KinesisModel> pushSetting(
    String partitionKey,
    Map<String, dynamic> event,
  );
  Future<KinesisModel> pushEvent(
    String partitionKey,
    Map<String, dynamic> event,
  );
}

class KinesisRemoteDataSourceImpl implements KinesisRemoteDataSource {
  final Kinesis kinesisClient;

  KinesisRemoteDataSourceImpl({required this.kinesisClient});

  @override
  Future<KinesisModel> pushSetting(
    String partitionKey,
    Map<String, dynamic> event,
  ) async {
    final result = await kinesisClient.putRecord(
      partitionKey: partitionKey,
      data: Uint8List.fromList(jsonEncode(event).codeUnits),
      streamName: KinesisConstants.kinesisStreamNameSetting,
    );
    return KinesisModel(
      sequenceNumber: result.sequenceNumber,
      shardId: result.shardId,
      encryptionType: result.encryptionType,
    );
  }

  @override
  Future<KinesisModel> pushEvent(
    String partitionKey,
    Map<String, dynamic> event,
  ) async {
    final result = await kinesisClient.putRecord(
      partitionKey: partitionKey,
      data: Uint8List.fromList(jsonEncode(event).codeUnits),
      streamName: KinesisConstants.kinesisStreamNameEvent,
    );
    return KinesisModel(
      sequenceNumber: result.sequenceNumber,
      shardId: result.shardId,
      encryptionType: result.encryptionType,
    );
  }
}
