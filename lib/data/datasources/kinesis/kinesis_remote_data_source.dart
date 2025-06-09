import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_client/kinesis_2013_12_02.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/data/models/kinesis/kinesis_model.dart';

final logger = Logger('KinesisRemoteDataSource');

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
      streamName: dotenv.env['KINESIS_SETTING_STREAM_NAME'],
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
    logger.info('pushEvent: $event');
    return KinesisModel(
      sequenceNumber: '123',
      shardId: '123',
      encryptionType: EncryptionType.none,
    );

    final result = await kinesisClient.putRecord(
      partitionKey: partitionKey,
      data: Uint8List.fromList(jsonEncode(event).codeUnits),
      streamName: dotenv.env['KINESIS_EVENT_STREAM_NAME'],
    );
    return KinesisModel(
      sequenceNumber: result.sequenceNumber,
      shardId: result.shardId,
      encryptionType: result.encryptionType,
    );
  }
}
