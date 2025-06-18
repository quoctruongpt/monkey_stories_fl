import 'package:equatable/equatable.dart';

class SyncTextData extends Equatable {
  final double startTime;
  final double endTime;
  final String text;

  const SyncTextData({
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  factory SyncTextData.fromJson(Map<String, dynamic> json) {
    return SyncTextData(
      startTime: (json['s'] as num).toDouble(),
      endTime: (json['e'] as num).toDouble(),
      text: json['w'] as String,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, text];
}
