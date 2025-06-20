import 'package:hive_flutter/hive_flutter.dart';
import 'package:monkey_stories/core/constants/kinesis.dart';
import 'package:monkey_stories/data/models/kinesis/cache_kinesis_model.dart';

abstract class KinesisCacheDataSource {
  Future<void> cacheRecord(
    String streamName,
    String partitionKey,
    Map<String, dynamic> event,
  );
  Future<List<CacheKinesisModel>> getCachedRecords();
  Future<void> deleteCachedRecord(CacheKinesisModel record);
  Future<void> clearCache();
}

class KinesisCacheDataSourceImpl implements KinesisCacheDataSource {
  // Use a constant for the box name for safety and consistency.
  static const _boxName = kinesisCacheBoxName;

  // Getter for the Hive box. Assumes the box is already opened.
  Box<CacheKinesisModel> get _box => Hive.box<CacheKinesisModel>(_boxName);

  @override
  Future<void> cacheRecord(
    String streamName,
    String partitionKey,
    Map<String, dynamic> event,
  ) async {
    final newRecord = CacheKinesisModel(
      streamName: streamName,
      partitionKey: partitionKey,
      event: event,
      // Using a key that is more likely to be unique
      id: '${DateTime.now().toIso8601String()}-${partitionKey}',
    );
    // Use the record's ID as the key in the Hive box.
    await _box.put(newRecord.id, newRecord);
  }

  @override
  Future<List<CacheKinesisModel>> getCachedRecords() async {
    // Hive's .values returns an iterable, so we convert it to a list.
    return _box.values.toList();
  }

  @override
  Future<void> deleteCachedRecord(CacheKinesisModel record) async {
    // HiveObjects can be deleted directly, which is very convenient.
    await record.delete();
  }

  @override
  Future<void> clearCache() async {
    // This clears all items from the box.
    await _box.clear();
  }
}
