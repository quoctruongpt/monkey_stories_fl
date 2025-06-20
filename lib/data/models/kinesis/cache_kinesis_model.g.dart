// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_kinesis_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheKinesisModelAdapter extends TypeAdapter<CacheKinesisModel> {
  @override
  final int typeId = 0;

  @override
  CacheKinesisModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheKinesisModel(
      streamName: fields[0] as String,
      partitionKey: fields[1] as String,
      event: (fields[2] as Map).cast<String, dynamic>(),
      id: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CacheKinesisModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.streamName)
      ..writeByte(1)
      ..write(obj.partitionKey)
      ..writeByte(2)
      ..write(obj.event)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheKinesisModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
