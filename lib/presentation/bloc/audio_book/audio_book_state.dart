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
  // Playlist Management
  final List<AudioBookItem> playlist;
  final int currentTrackIndex;
  final bool isAutoplayEnabled;
  final bool showBuyToUnlockPopup;

  // Transcript Management for the current track
  final List<SyncTextData> transcript;
  final List<String> paragraphs;
  final List<int> sentenceToParagraphMap;
  final bool shouldNavigateBack;
  final bool isTimerActive;
  final Duration? timerDuration;
  final Duration? remainingTime;
  final int currentViewIndex;

  // Player Status
  final Duration currentPosition;
  final Duration totalDuration;
  final int currentLineIndex;
  final AudioPlayerStatus status;
  final String? errorMessage;

  const AudioBookState({
    this.playlist = const [],
    this.currentTrackIndex = 0,
    this.isAutoplayEnabled = false,
    this.transcript = const [],
    this.paragraphs = const [],
    this.sentenceToParagraphMap = const [],
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentLineIndex = -1,
    this.status = AudioPlayerStatus.initial,
    this.errorMessage,
    this.shouldNavigateBack = false,
    this.isTimerActive = false,
    this.timerDuration,
    this.remainingTime,
    this.currentViewIndex = 0,
    this.showBuyToUnlockPopup = false,
  });

  AudioBookState copyWith({
    List<AudioBookItem>? playlist,
    int? currentTrackIndex,
    bool? isAutoplayEnabled,
    List<SyncTextData>? transcript,
    List<String>? paragraphs,
    List<int>? sentenceToParagraphMap,
    Duration? currentPosition,
    Duration? totalDuration,
    int? currentLineIndex,
    AudioPlayerStatus? status,
    String? errorMessage,
    bool? shouldNavigateBack,
    bool? clearTranscript,
    bool? isTimerActive,
    Duration? timerDuration,
    Duration? remainingTime,
    bool? clearTimer,
    int? currentViewIndex,
    bool? showBuyToUnlockPopup,
  }) {
    return AudioBookState(
      playlist: playlist ?? this.playlist,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      isAutoplayEnabled: isAutoplayEnabled ?? this.isAutoplayEnabled,
      transcript: clearTranscript == true ? [] : transcript ?? this.transcript,
      paragraphs: clearTranscript == true ? [] : paragraphs ?? this.paragraphs,
      sentenceToParagraphMap:
          clearTranscript == true
              ? []
              : sentenceToParagraphMap ?? this.sentenceToParagraphMap,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      currentLineIndex:
          clearTranscript == true
              ? -1
              : currentLineIndex ?? this.currentLineIndex,
      status: status ?? this.status,
      errorMessage: errorMessage,
      shouldNavigateBack: shouldNavigateBack ?? this.shouldNavigateBack,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      timerDuration:
          clearTimer == true ? null : timerDuration ?? this.timerDuration,
      remainingTime:
          clearTimer == true ? null : remainingTime ?? this.remainingTime,
      currentViewIndex: currentViewIndex ?? this.currentViewIndex,
      showBuyToUnlockPopup: showBuyToUnlockPopup ?? this.showBuyToUnlockPopup,
    );
  }

  @override
  List<Object?> get props => [
    playlist,
    currentTrackIndex,
    isAutoplayEnabled,
    transcript,
    paragraphs,
    sentenceToParagraphMap,
    currentPosition,
    totalDuration,
    currentLineIndex,
    status,
    errorMessage,
    shouldNavigateBack,
    isTimerActive,
    timerDuration,
    remainingTime,
    currentViewIndex,
    showBuyToUnlockPopup,
  ];
}
