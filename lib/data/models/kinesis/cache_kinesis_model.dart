// A model to represent a cached Kinesis record.
class CachedKinesisRecord {
  final String streamName;
  final String partitionKey;
  final Map<String, dynamic> event;
  final String id; // Unique ID for each record to make deletion easier.

  CachedKinesisRecord({
    required this.streamName,
    required this.partitionKey,
    required this.event,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'streamName': streamName,
    'partitionKey': partitionKey,
    'event': event,
  };

  factory CachedKinesisRecord.fromJson(Map<String, dynamic> json) =>
      CachedKinesisRecord(
        id: json['id'],
        streamName: json['streamName'],
        partitionKey: json['partitionKey'],
        event: Map<String, dynamic>.from(json['event']),
      );
}
