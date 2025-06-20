import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:monkey_stories/data/models/kinesis/cache_kinesis_model.dart';

abstract class KinesisCacheDataSource {
  Future<void> cacheRecord(
    String streamName,
    String partitionKey,
    Map<String, dynamic> event,
  );
  Future<List<CachedKinesisRecord>> getCachedRecords();
  Future<void> deleteCachedRecord(String id);
  Future<void> clearCache();
}

class KinesisCacheDataSourceImpl implements KinesisCacheDataSource {
  static const _cacheFileName = 'kinesis_cache.json';

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_cacheFileName');
  }

  @override
  Future<void> cacheRecord(
    String streamName,
    String partitionKey,
    Map<String, dynamic> event,
  ) async {
    final file = await _localFile;
    final records = await getCachedRecords();

    final newRecord = CachedKinesisRecord(
      streamName: streamName,
      partitionKey: partitionKey,
      event: event,
      id: DateTime.now().toIso8601String() + partitionKey, // simple unique id
    );

    records.add(newRecord);

    await file.writeAsString(
      jsonEncode(records.map((r) => r.toJson()).toList()),
    );
  }

  @override
  Future<List<CachedKinesisRecord>> getCachedRecords() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList
          .map((json) => CachedKinesisRecord.fromJson(json))
          .toList();
    } catch (e) {
      // If there's an error reading the file (e.g., corrupted), clear it.
      await clearCache();
      return [];
    }
  }

  @override
  Future<void> deleteCachedRecord(String id) async {
    final file = await _localFile;
    final records = await getCachedRecords();
    records.removeWhere((record) => record.id == id);
    await file.writeAsString(
      jsonEncode(records.map((r) => r.toJson()).toList()),
    );
  }

  @override
  Future<void> clearCache() async {
    final file = await _localFile;
    if (await file.exists()) {
      await file.delete();
    }
  }
}
