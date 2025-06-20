class KinesisEntity {
  final String sequenceNumber;
  final String? shardId;

  KinesisEntity({required this.sequenceNumber, this.shardId});

  Map<String, dynamic> toJson() {
    return {'sequence_number': sequenceNumber, 'shard_id': shardId};
  }
}
