// Package imports:
import 'package:hive/hive.dart';

part 'cache_kinesis_model.g.dart';

@HiveType(typeId: 0)
class CacheKinesisModel extends HiveObject {
  @HiveField(0)
  final String streamName;

  @HiveField(1)
  final String partitionKey;

  @HiveField(2)
  final Map<String, dynamic> event;

  @HiveField(3)
  final String id;

  CacheKinesisModel({
    required this.streamName,
    required this.partitionKey,
    required this.event,
    required this.id,
  });
}
