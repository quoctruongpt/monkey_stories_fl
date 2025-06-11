part of 'audio_book_cubit.dart';

enum AudioPlayerStatus {
  initial,
  loading,
  playing,
  paused,
  stopped,
  completed,
  error,
}

class AudioBookState extends Equatable {
  final List<SyncTextData> transcript;
  final List<String> paragraphs;
  final List<int> sentenceToParagraphMap;
  final Duration currentPosition;
  final Duration totalDuration;
  final int currentLineIndex;
  final AudioPlayerStatus status;
  final String? errorMessage;

  const AudioBookState({
    this.transcript = const [],
    this.paragraphs = const [],
    this.sentenceToParagraphMap = const [],
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentLineIndex = -1,
    this.status = AudioPlayerStatus.initial,
    this.errorMessage,
  });

  AudioBookState copyWith({
    List<SyncTextData>? transcript,
    List<String>? paragraphs,
    List<int>? sentenceToParagraphMap,
    Duration? currentPosition,
    Duration? totalDuration,
    int? currentLineIndex,
    AudioPlayerStatus? status,
    String? errorMessage,
  }) {
    return AudioBookState(
      transcript: transcript ?? this.transcript,
      paragraphs: paragraphs ?? this.paragraphs,
      sentenceToParagraphMap:
          sentenceToParagraphMap ?? this.sentenceToParagraphMap,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      currentLineIndex: currentLineIndex ?? this.currentLineIndex,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    transcript,
    paragraphs,
    sentenceToParagraphMap,
    currentPosition,
    totalDuration,
    currentLineIndex,
    status,
    errorMessage,
  ];
}
