import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/data/models/audio_book/audio_book_item.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(const PlaylistState());

  /// Sets the playlist that the audio player will use.
  /// This should be called from the screen that prepares the audio content,
  /// before navigating to the AudioBookPage.
  void setPlaylist(List<Map<String, dynamic>> playlistMap) {
    try {
      final playlist =
          playlistMap.map((data) => AudioBookItem.fromJson(data)).toList();
      emit(state.copyWith(playlist: playlist));
    } catch (e) {
      print('setPlaylist error: $e');
      // Handle potential parsing errors
      emit(state.copyWith(playlist: []));
    }
  }
}
