import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/data/models/audio_book/audio_book_item.dart';
import 'package:monkey_stories/data/models/audio_book/sync_text_data.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:rxdart/rxdart.dart';

part 'audio_book_state.dart';

class AudioBookCubit extends Cubit<AudioBookState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  final Logger logger = Logger('AudioBookCubit');
  Timer? _countdownTimer;

  final UserCubit _userCubit;

  AudioBookCubit({required UserCubit userCubit})
    : _userCubit = userCubit,
      super(const AudioBookState()) {
    _init();
  }

  AudioSource _createAudioSource(AudioBookItem item) {
    // Create a MediaItem with metadata for the notification
    final mediaItem = MediaItem(
      id: item.id.toString(),
      title: item.name,
      // For assets, the URI must be in the 'asset:///' format.
      artUri:
          item.isDownloaded && item.localThumbPath != null
              ? Uri.parse('asset:///${item.localThumbPath}')
              : null, // Placeholder can be added here if needed
      duration: Duration(seconds: item.duration),
    );

    if (item.isDownloaded && item.localAudioPath != null) {
      logger.info(
        'Creating source for ${item.name} from asset: ${item.localAudioPath}',
      );
      return AudioSource.asset(item.localAudioPath!, tag: mediaItem);
    } else {
      logger.warning(
        'Creating placeholder source for non-downloaded track: ${item.name}',
      );
      return AudioSource.asset('assets/audio/aaa.mp3', tag: mediaItem);
    }
  }

  void _init() {
    _positionSubscription = _audioPlayer.positionStream
        .throttleTime(const Duration(milliseconds: 200))
        .listen((position) {
          // Logic xử lý câu nào đang được phát dựa vào thời gian phát
          final currentTranscript = state.transcript;
          if (currentTranscript.isNotEmpty) {
            final currentIndex = state.currentLineIndex;
            final newIndex = currentTranscript.lastIndexWhere(
              (line) =>
                  position.inMilliseconds >= line.startTime &&
                  position.inMilliseconds <= line.endTime,
            );

            if (newIndex != -1 && newIndex != currentIndex) {
              emit(state.copyWith(currentLineIndex: newIndex));
            }
          }

          if (position.inSeconds > 0 &&
              _audioPlayer.duration!.inSeconds - position.inSeconds <= 1 &&
              _audioPlayer.loopMode == LoopMode.one &&
              _audioPlayer.playing) {
            _audioPlayer.pause();
            _audioPlayer.seek(Duration.zero);
            emit(state.copyWith(shouldNavigateBack: true));
          }

          emit(state.copyWith(currentPosition: position));
        });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      // Timer logic must be first to react to play/pause state changes
      if (state.isTimerActive) {
        if (playerState.playing) {
          _startCountdown();
        } else {
          _stopCountdown();
        }
      }

      final status = _mapPlayerStateToStatus(playerState.processingState);
      emit(state.copyWith(status: status));

      // Handle playlist completion for Autoplay ON
      if (playerState.processingState == ProcessingState.completed &&
          _audioPlayer.loopMode == LoopMode.off) {
        logger.info(
          'Playlist completed with autoplay on. Requesting navigation back.',
        );
        emit(state.copyWith(shouldNavigateBack: true));
      }
    });

    // Xử lý khi chuyển bài và tự động download bài tiếp theo
    _currentIndexSubscription = _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index != state.currentTrackIndex) {
        emit(state.copyWith(currentTrackIndex: index, clearTranscript: true));
        _loadTranscriptForTrack(index);
        _downloadTrackIfNeeded(index - 1);
        _downloadTrackIfNeeded(index + 1);
      }
    });

    // Xử lý tổng thời lượng bài
    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      logger.info('duration: $duration');
      if (duration != null) {
        emit(state.copyWith(totalDuration: duration));
      }
    });
  }

  void initStateAutoPlay(bool isPlayAll) {
    setAutoplay(isPlayAll && _userCubit.state.purchasedInfo!.isActive);
  }

  Future<void> loadPlaylist({
    required List<AudioBookItem> playlist,
    int? audioSelectedId,
  }) async {
    try {
      emit(state.copyWith(status: AudioPlayerStatus.loading));

      int initialIndex = 0;
      if (audioSelectedId != null) {
        final index = playlist.indexWhere(
          (track) => track.id == audioSelectedId,
        );
        if (index != -1) {
          initialIndex = index;
        }
      }

      final audioSources = playlist.map(_createAudioSource).toList();
      final concatenatingAudioSource = ConcatenatingAudioSource(
        children: audioSources,
      );

      await _audioPlayer.setAudioSource(
        concatenatingAudioSource,
        initialIndex: initialIndex,
        preload: false,
      );

      emit(
        state.copyWith(
          playlist: playlist,
          status: AudioPlayerStatus.paused,
          currentTrackIndex: initialIndex,
        ),
      );

      _loadTranscriptForTrack(initialIndex);
      _downloadTrackIfNeeded(initialIndex - 1);
      _downloadTrackIfNeeded(initialIndex + 1);

      // Autoplay the selected track
      play();

      initStateAutoPlay(audioSelectedId == null);
    } catch (e, stacktrace) {
      logger.severe('Error loading playlist', e, stacktrace);
      emit(
        state.copyWith(
          status: AudioPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _checkPaidLockedAudio(int index) {
    if (index < 0 || index >= state.playlist.length) return;
    final track = state.playlist[index];
    logger.info('checkPaidLockedAudio: ${track.name}');
    if (!track.isFree && !_userCubit.state.purchasedInfo!.isActive) {
      emit(state.copyWith(showBuyToUnlockPopup: true));
      pause();
    }
  }

  Future<void> _loadTranscriptForTrack(int index) async {
    if (index < 0 || index >= state.playlist.length) {
      return; // Index is out of bounds, do nothing.
    }
    final track = state.playlist[index];
    if (!track.isDownloaded || track.localSyncTextPath == null) {
      // Handle case where transcript is not available
      emit(
        state.copyWith(
          transcript: [],
          paragraphs: [],
          sentenceToParagraphMap: [],
        ),
      );
      return;
    }

    try {
      final syncTextPath = track.localSyncTextPath!;
      final transcriptString = await rootBundle.loadString(syncTextPath);
      final transcriptJson = json.decode(transcriptString) as List;
      final transcript =
          transcriptJson.map((item) => SyncTextData.fromJson(item)).toList();

      // Assuming data.json is now coupled with the track or we use a convention
      // For now, let's assume a corresponding data.json for the first track for demo purposes
      final dataString = await rootBundle.loadString('assets/data/data.json');
      final dataJson = json.decode(dataString) as Map<String, dynamic>;
      final contentPath = dataJson['content_path'] as String;
      final paragraphs = contentPath.split('\n');

      final sentenceToParaMap = <int>[];
      int sentenceIdx = 0;
      for (int paraIdx = 0; paraIdx < paragraphs.length; paraIdx++) {
        final paraClean =
            paragraphs[paraIdx].replaceAll(RegExp(r'[*]'), '').trim();
        if (paraClean.isEmpty) continue;
        String reconstructedPara = '';
        int startingSentenceIdx = sentenceIdx;

        while (sentenceIdx < transcript.length) {
          reconstructedPara += transcript[sentenceIdx].text.trim() + ' ';
          sentenceIdx++;
          // A more robust check might be needed depending on punctuation
          if (reconstructedPara.trim().length >= paraClean.length) {
            break;
          }
        }
        // Now assign all processed sentences to the current paragraph index
        for (int i = startingSentenceIdx; i < sentenceIdx; i++) {
          sentenceToParaMap.add(paraIdx);
        }
      }

      // Safeguard: if the map is shorter than the transcript, assign remaining
      // sentences to the last paragraph. This can happen with trailing sentences.
      while (sentenceToParaMap.length < transcript.length) {
        sentenceToParaMap.add(
          paragraphs.isNotEmpty ? paragraphs.length - 1 : 0,
        );
      }

      emit(
        state.copyWith(
          transcript: transcript,
          paragraphs: paragraphs,
          sentenceToParagraphMap: sentenceToParaMap,
        ),
      );
    } catch (e, stacktrace) {
      logger.severe('Error loading transcript for track $index', e, stacktrace);
      emit(
        state.copyWith(
          status: AudioPlayerStatus.error,
          errorMessage: "Failed to load lyrics.",
        ),
      );
    }
  }

  Future<dynamic> _fakeDownload() async {
    await Future.delayed(const Duration(seconds: 3));
    final dataString = await rootBundle.loadString('assets/data/test.json');
    final dataJson = json.decode(dataString) as Map<String, dynamic>;
    final localAudioPath = dataJson['payload']['localAudioPath'] as String;
    final localSyncTextPath =
        dataJson['payload']['localSyncTextPath'] as String;
    return {
      'localAudioPath': localAudioPath,
      'localSyncTextPath': localSyncTextPath,
    };
  }

  Future<void> _downloadTrackIfNeeded(int index) async {
    if (index >= state.playlist.length || index < 0) return; // Out of bounds

    var trackToDownload = state.playlist[index];
    if (trackToDownload.isDownloaded || trackToDownload.isDownloading) {
      return; // Already downloaded or currently downloading
    }

    // Mark as downloading
    _updateTrackInPlaylist(
      index,
      trackToDownload.copyWith(isDownloading: true),
    );

    logger.info('Simulating download for track: ${trackToDownload.name}');
    final fakeDownload = await _fakeDownload();

    // In a real app, you would get these paths from your download manager.
    final fakeAudioPath = fakeDownload['localAudioPath'] as String;
    final fakeSyncTextPath = fakeDownload['localSyncTextPath'] as String;

    // Mark as downloaded
    final updatedTrack = trackToDownload.copyWith(
      isDownloading: false,
      isDownloaded: true,
      localAudioPath: fakeAudioPath,
      localSyncTextPath: fakeSyncTextPath,
    );
    _updateTrackInPlaylist(index, updatedTrack);

    logger.info('Finished downloading track: ${updatedTrack.name}');

    // Update the audio player's source to point to the downloaded file.
    final currentSource = _audioPlayer.audioSource;
    if (currentSource is ConcatenatingAudioSource) {
      try {
        logger.info('Updating audio source in player for track index: $index');
        final newSource = _createAudioSource(updatedTrack);
        // Atomically remove the old source and insert the new one.
        await currentSource.removeAt(index);
        await currentSource.insert(index, newSource);
        logger.info(
          'Successfully updated audio source for track index: $index',
        );
      } catch (e, stacktrace) {
        logger.severe(
          'Error updating audio source at index $index',
          e,
          stacktrace,
        );
      }
    }
  }

  void _updateTrackInPlaylist(int index, AudioBookItem updatedTrack) {
    final updatedPlaylist = List<AudioBookItem>.from(state.playlist);
    updatedPlaylist[index] = updatedTrack;
    emit(state.copyWith(playlist: updatedPlaylist));
  }

  Future<void> next() async {
    // Temporarily disable LoopMode.one to correctly check hasNext
    // and to allow moving to the next track.
    final originalLoopMode = _audioPlayer.loopMode;
    if (originalLoopMode == LoopMode.one) {
      await _audioPlayer.setLoopMode(LoopMode.off);
    }

    // Exit if there is no next track
    if (!_audioPlayer.hasNext) {
      if (originalLoopMode == LoopMode.one) {
        await _audioPlayer.setLoopMode(originalLoopMode);
      }
      return;
    }

    final nextIndex = _audioPlayer.currentIndex! + 1;
    final nextTrack = state.playlist[nextIndex];
    _checkPaidLockedAudio(nextIndex);

    if (!nextTrack.isDownloaded) {
      // If the track is not downloaded, pause playback.
      pause();
      // Seek to the new track (it will be a placeholder). This updates the UI focus.
      await _audioPlayer.seek(Duration.zero, index: nextIndex);
      // Start the download. The UI will show a loading indicator.
      // We await this to ensure the source is updated before any potential playback.
      await _downloadTrackIfNeeded(nextIndex);
      // After downloading, the player will remain paused for the user to resume.
    } else {
      // If the track is already downloaded, simply seek to it.
      // The player will continue playing if it was already in a playing state.
      await _audioPlayer.seekToNext();
    }

    // Restore the original loop mode
    if (originalLoopMode == LoopMode.one) {
      await _audioPlayer.setLoopMode(originalLoopMode);
    }
  }

  Future<void> previous() async {
    // Temporarily disable LoopMode.one to correctly check hasPrevious
    // and to allow moving to the previous track.
    final originalLoopMode = _audioPlayer.loopMode;
    if (originalLoopMode == LoopMode.one) {
      await _audioPlayer.setLoopMode(LoopMode.off);
    }

    // Exit if there is no previous track
    if (!_audioPlayer.hasPrevious) {
      if (originalLoopMode == LoopMode.one) {
        await _audioPlayer.setLoopMode(originalLoopMode);
      }
      return;
    }

    final prevIndex = _audioPlayer.currentIndex! - 1;
    final prevTrack = state.playlist[prevIndex];
    _checkPaidLockedAudio(prevIndex);

    if (!prevTrack.isDownloaded) {
      // If the track is not downloaded, pause playback.
      pause();
      // Seek to the new track (it will be a placeholder). This updates the UI focus.
      await _audioPlayer.seek(Duration.zero, index: prevIndex);
      // Start the download. The UI will show a loading indicator.
      await _downloadTrackIfNeeded(prevIndex);
      // After downloading, the player will remain paused for the user to resume.
    } else {
      // If the track is already downloaded, simply seek to it.
      // The player will continue playing if it was already in a playing state.
      await _audioPlayer.seekToPrevious();
    }

    // Restore the original loop mode
    if (originalLoopMode == LoopMode.one) {
      await _audioPlayer.setLoopMode(originalLoopMode);
    }
  }

  Future<void> skipToTrack(int index) async {
    final track = state.playlist[index];
    _checkPaidLockedAudio(index);

    if (!track.isDownloaded) {
      // If the track is not downloaded, pause playback.
      pause();
      // Start the download. The UI will show a loading indicator.
      await _downloadTrackIfNeeded(index);
      // Seek to the new track (it will be a placeholder). This updates the UI focus.
      await _audioPlayer.seek(Duration.zero, index: index);
      play();
      // After downloading, the player remains paused. User must tap play.
    } else {
      // If the track is already downloaded, seek to it and play.
      await _audioPlayer.seek(Duration.zero, index: index);
      if (!_audioPlayer.playing) {
        play();
      }
    }
    _checkPaidLockedAudio(index);
    emit(state.copyWith(currentViewIndex: 0));
  }

  void setAutoplay(bool isEnabled) {
    emit(state.copyWith(isAutoplayEnabled: isEnabled));
    _audioPlayer.setLoopMode(isEnabled ? LoopMode.off : LoopMode.one);

    if (isEnabled) {
      setTimer(const Duration(minutes: 30));
    } else {
      cancelTimer();
    }
  }

  void setTimer(Duration duration) {
    _stopCountdown(); // Stop any previous timer
    emit(
      state.copyWith(
        isTimerActive: true,
        timerDuration: duration,
        remainingTime: duration,
      ),
    );
    if (_audioPlayer.playing) {
      _startCountdown();
    }
  }

  void cancelTimer() {
    _stopCountdown();
    emit(state.copyWith(isTimerActive: false, clearTimer: true));
  }

  void _startCountdown() {
    if (_countdownTimer?.isActive ?? false) return; // Already running

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime == null || !state.isTimerActive) {
        timer.cancel();
        return;
      }
      final newTime = state.remainingTime! - const Duration(seconds: 1);

      if (newTime.isNegative) {
        timer.cancel();
        _audioPlayer.stop(); // Stop the player before navigating back
        emit(
          state.copyWith(
            shouldNavigateBack: true,
            isTimerActive: false,
            clearTimer: true,
          ),
        );
      } else {
        emit(state.copyWith(remainingTime: newTime));
      }
    });
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void play() {
    if (_audioPlayer.processingState == ProcessingState.completed) {
      _audioPlayer.seek(Duration.zero).then((_) {
        _audioPlayer.play();
        _checkPaidLockedAudio(state.currentTrackIndex);
      });
    } else {
      _audioPlayer.play();
      _checkPaidLockedAudio(state.currentTrackIndex);
    }
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void togglePlaylistView() {
    final nextIndex = state.currentViewIndex == 0 ? 1 : 0;
    emit(state.copyWith(currentViewIndex: nextIndex));
  }

  AudioPlayerStatus _mapPlayerStateToStatus(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioPlayerStatus.initial;
      case ProcessingState.loading:
        return AudioPlayerStatus.loading;
      case ProcessingState.buffering:
      case ProcessingState.ready:
        return _audioPlayer.playing
            ? AudioPlayerStatus.playing
            : AudioPlayerStatus.paused;
      case ProcessingState.completed:
        return AudioPlayerStatus.completed;
    }
  }

  void reorderPlaylist(int oldIndex, int newIndex) {
    logger.info('Reordering playlist from $oldIndex to $newIndex');

    // The `onReorder` callback in ReorderableListView gives the new index
    // as if the item was already removed. If we move down the list,
    // we need to adjust the index.
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final currentPlaylist = List<AudioBookItem>.from(state.playlist);
    final movedItem = currentPlaylist.removeAt(oldIndex);
    currentPlaylist.insert(newIndex, movedItem);

    // Update the audio source
    final audioSource = _audioPlayer.audioSource as ConcatenatingAudioSource;
    audioSource.move(oldIndex, newIndex);

    // Update the current playing index
    int newCurrentIndex = state.currentTrackIndex;
    if (state.currentTrackIndex == oldIndex) {
      newCurrentIndex = newIndex;
    } else if (oldIndex < state.currentTrackIndex &&
        newIndex >= state.currentTrackIndex) {
      newCurrentIndex--;
    } else if (oldIndex > state.currentTrackIndex &&
        newIndex <= state.currentTrackIndex) {
      newCurrentIndex++;
    }

    emit(
      state.copyWith(
        playlist: currentPlaylist,
        currentTrackIndex: newCurrentIndex,
      ),
    );

    logger.info('Playlist reordered. New current index: $newCurrentIndex');
  }

  void showBuyToUnlockPopup() {
    emit(state.copyWith(showBuyToUnlockPopup: true));
  }

  void closeBuyToUnlockPopup() {
    emit(state.copyWith(showBuyToUnlockPopup: false));
  }

  @override
  void emit(AudioBookState state) {
    if (isClosed) return;
    super.emit(state);
  }

  @override
  Future<void> close() {
    _currentIndexSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _stopCountdown();
    _audioPlayer.dispose();
    return super.close();
  }
}
