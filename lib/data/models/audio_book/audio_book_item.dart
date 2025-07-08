// Package imports:
import 'package:equatable/equatable.dart';

class AudioBookItem extends Equatable {
  final int id;
  final String name;
  final int duration;
  final String content;
  final bool isDownloading;
  final String? localAudioPath;
  final String? localThumbPath;
  final bool isFree;

  const AudioBookItem({
    required this.id,
    required this.name,
    required this.duration,
    required this.content,
    this.isDownloading = false,
    this.localAudioPath,
    this.localThumbPath,
    this.isFree = false,
  });

  AudioBookItem copyWith({
    String? content,
    bool? isDownloading,
    String? localAudioPath,
    String? localThumbPath,
    bool? isFree,
  }) {
    return AudioBookItem(
      id: id,
      name: name,
      duration: duration,
      content: content ?? this.content,
      isDownloading: isDownloading ?? this.isDownloading,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      localThumbPath: localThumbPath ?? this.localThumbPath,
      isFree: isFree ?? this.isFree,
    );
  }

  factory AudioBookItem.fromJson(Map<String, dynamic> json) {
    return AudioBookItem(
      id: json['id'] as int,
      name: json['name'] as String,
      duration: json['duration'] as int,
      content: json['content'] as String,
      isDownloading: json['isDownloading'] ?? false,
      localAudioPath: json['localAudioPath'] as String?,
      localThumbPath: json['localThumbPath'] as String?,
      isFree: json['isFree'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    duration,
    content,
    isDownloading,
    localAudioPath,
    localThumbPath,
    isFree,
  ];
}
