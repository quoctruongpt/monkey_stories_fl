import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aws_client/kinesis_2013_12_02.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/data/datasources/kinesis/kinesis_cache_data_source.dart';
import 'package:monkey_stories/data/models/kinesis/kinesis_model.dart';
import 'package:monkey_stories/data/models/kinesis/cache_kinesis_model.dart';

final logger = Logger('KinesisRemoteDataSource');

abstract class KinesisRemoteDataSource {
  Future<KinesisModel?> pushSetting(
    String partitionKey,
    Map<String, dynamic> event,
  );
  Future<KinesisModel?> pushEvent(
    String partitionKey,
    Map<String, dynamic> event,
  );
  Future<KinesisModel?> putRecordToKinesis({
    required String streamName,
    required String partitionKey,
    required Map<String, dynamic> event,
  });
  Future<void> retryCachedEvents();
}

class KinesisRemoteDataSourceImpl implements KinesisRemoteDataSource {
  final Kinesis kinesisClient;
  final KinesisCacheDataSource cacheDataSource;

  KinesisRemoteDataSourceImpl({
    required this.kinesisClient,
    required this.cacheDataSource,
  });

  @override
  Future<KinesisModel?> pushSetting(
    String partitionKey,
    Map<String, dynamic> event,
  ) async {
    final result = await putRecordToKinesis(
      streamName: dotenv.env['KINESIS_SETTING_STREAM_NAME']!,
      partitionKey: partitionKey,
      event: event,
    );

    return result;
  }

  @override
  Future<KinesisModel?> pushEvent(
    String partitionKey,
    Map<String, dynamic> event,
  ) async {
    logger.info('pushEvent: $event');

    final result = await putRecordToKinesis(
      streamName: dotenv.env['KINESIS_EVENT_STREAM_NAME']!,
      partitionKey: partitionKey,
      event: event,
    );

    return result;
  }

  @override
  Future<KinesisModel?> putRecordToKinesis({
    required String streamName,
    required String partitionKey,
    required Map<String, dynamic> event,
  }) async {
    try {
      final result = await kinesisClient.putRecord(
        partitionKey: partitionKey,
        data: Uint8List.fromList(jsonEncode(event).codeUnits),
        streamName: streamName,
      );
      return KinesisModel(
        sequenceNumber: result.sequenceNumber,
        shardId: result.shardId,
        encryptionType: result.encryptionType,
      );
    } on SocketException catch (e) {
      logger.warning('Failed to send event to Kinesis, caching...', e);
      await cacheDataSource.cacheRecord(streamName, partitionKey, event);
      return null;
    } catch (e) {
      logger.severe(
        'An unexpected error occurred while sending event to Kinesis. Caching...',
        e,
      );
      await cacheDataSource.cacheRecord(streamName, partitionKey, event);
      return null;
    }
  }

  @override
  Future<void> retryCachedEvents() async {
    logger.info('Retrying cached Kinesis events...');
    final List<CacheKinesisModel> cachedRecords =
        await cacheDataSource.getCachedRecords();

    if (cachedRecords.isEmpty) {
      logger.info('No cached Kinesis events to retry.');
      return;
    }

    logger.info('Found ${cachedRecords.length} cached events to retry.');

    for (final record in cachedRecords) {
      try {
        // We don't use the public pushEvent/pushSetting methods to avoid recursion
        // in case they are overridden with more logic.
        // We call the core method directly.
        final result = await kinesisClient.putRecord(
          partitionKey: record.partitionKey,
          data: Uint8List.fromList(jsonEncode(record.event).codeUnits),
          streamName: record.streamName,
        );

        // If successful, remove from cache
        await cacheDataSource.deleteCachedRecord(record);
        logger.info(
          'Successfully retried and removed cached event: ${record.id} -> ${result.sequenceNumber}',
        );
      } catch (e) {
        logger.warning(
          'Failed to retry cached event: ${record.id}. Will try again later.',
          e,
        );
        // Stop retrying on the first failure to avoid a storm of requests
        // if the connection is still down.
        break;
      }
    }
  }
}
