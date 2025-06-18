import 'package:equatable/equatable.dart';

class AudioBookItem extends Equatable {
  final int id;
  final String name;
  final int duration;
  final bool isDownloaded;
  final bool isDownloading;
  final String? localAudioPath;
  final String? localSyncTextPath;
  final String? localThumbPath;
  final bool isFree;

  const AudioBookItem({
    required this.id,
    required this.name,
    required this.duration,
    required this.isDownloaded,
    this.isDownloading = false,
    this.localAudioPath,
    this.localSyncTextPath,
    this.localThumbPath,
    this.isFree = false,
  });

  AudioBookItem copyWith({
    bool? isDownloaded,
    bool? isDownloading,
    String? localAudioPath,
    String? localSyncTextPath,
    String? localThumbPath,
    bool? isFree,
  }) {
    return AudioBookItem(
      id: id,
      name: name,
      duration: duration,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isDownloading: isDownloading ?? this.isDownloading,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      localSyncTextPath: localSyncTextPath ?? this.localSyncTextPath,
      localThumbPath: localThumbPath ?? this.localThumbPath,
      isFree: isFree ?? this.isFree,
    );
  }

  factory AudioBookItem.fromJson(Map<String, dynamic> json) {
    return AudioBookItem(
      id: json['id'] as int,
      name: json['name'] as String,
      duration: json['duration'] as int,
      isDownloaded: json['isDownloaded'] as bool,
      isDownloading: json['isDownloading'] ?? false,
      localAudioPath: json['localAudioPath'] as String?,
      localSyncTextPath: json['localSyncTextPath'] as String?,
      localThumbPath: json['localThumbPath'] as String?,
      isFree: json['isFree'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    duration,
    isDownloaded,
    isDownloading,
    localAudioPath,
    localSyncTextPath,
    localThumbPath,
    isFree,
  ];
}
