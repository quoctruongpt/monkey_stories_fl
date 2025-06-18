part of 'playlist_cubit.dart';

class PlaylistState extends Equatable {
  const PlaylistState({this.playlist = const []});

  final List<AudioBookItem> playlist;

  PlaylistState copyWith({List<AudioBookItem>? playlist}) {
    return PlaylistState(playlist: playlist ?? this.playlist);
  }

  @override
  List<Object> get props => [playlist];
}
