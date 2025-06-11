import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/data/models/audio_book/sync_text_data.dart';

part 'audio_book_state.dart';

final logger = Logger('AudioBookCubit');

class AudioBookCubit extends Cubit<AudioBookState> {
  final AudioPlayer _audioPlayer;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  AudioBookCubit()
    : _audioPlayer = AudioPlayer(),
      super(const AudioBookState()) {
    _init();
  }

  void _init() {
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      final currentTranscript = state.transcript;
      if (currentTranscript.isEmpty) return;

      final currentIndex = state.currentLineIndex;
      final newIndex = currentTranscript.lastIndexWhere(
        (line) =>
            position.inMilliseconds >= line.startTime &&
            position.inMilliseconds <= line.endTime,
      );

      if (newIndex != -1 && newIndex != currentIndex) {
        emit(state.copyWith(currentLineIndex: newIndex));
      }
      emit(state.copyWith(currentPosition: position));
    });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      final status = _mapPlayerStateToStatus(playerState.processingState);
      emit(state.copyWith(status: status));
    });
  }

  Future<void> loadAudioBook() async {
    try {
      emit(state.copyWith(status: AudioPlayerStatus.loading));

      // Load sentences from sync_text.json
      final transcriptString = await rootBundle.loadString(
        'assets/data/sync_text.json',
      );
      final transcriptJson = json.decode(transcriptString) as List;
      final transcript =
          transcriptJson.map((item) => SyncTextData.fromJson(item)).toList();

      // Load paragraphs from data.json
      final dataString = await rootBundle.loadString('assets/data/data.json');
      final dataJson = json.decode(dataString) as Map<String, dynamic>;
      final contentPath = dataJson['content_path'] as String;
      // Split by single newline to treat each line as a paragraph.
      final paragraphs = contentPath.split('\n');

      // Build the map from sentence index to paragraph index
      final sentenceToParaMap = <int>[];
      int sentenceIdx = 0;
      for (int paraIdx = 0; paraIdx < paragraphs.length; paraIdx++) {
        final paraClean =
            paragraphs[paraIdx].replaceAll(RegExp(r'[*]'), '').trim();

        // Skip empty lines, they are just for spacing.
        if (paraClean.isEmpty) {
          continue;
        }

        String reconstructedPara = '';
        while (sentenceIdx < transcript.length) {
          sentenceToParaMap.add(paraIdx);
          reconstructedPara += transcript[sentenceIdx].text.trim() + ' ';
          sentenceIdx++;
          if (reconstructedPara.replaceAll(' ', '').length >=
              paraClean.replaceAll(' ', '').length) {
            break;
          }
        }
      }

      final duration = await _audioPlayer.setAsset('assets/audio/aaa.mp3');

      emit(
        state.copyWith(
          transcript: transcript,
          paragraphs: paragraphs,
          sentenceToParagraphMap: sentenceToParaMap,
          status: AudioPlayerStatus.paused,
          totalDuration: duration ?? Duration.zero,
        ),
      );
    } catch (e) {
      logger.severe('Error loading audio book $e');
      emit(
        state.copyWith(
          status: AudioPlayerStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void play() {
    if (_audioPlayer.processingState == ProcessingState.completed) {
      _audioPlayer.seek(Duration.zero).then((_) {
        _audioPlayer.play();
      });
    } else {
      _audioPlayer.play();
    }
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
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

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
