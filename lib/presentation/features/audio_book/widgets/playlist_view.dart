import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/lottie_utils.dart';
import 'package:monkey_stories/core/utils/number.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/audio_book/audio_book_cubit.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({super.key});

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important for AutomaticKeepAliveClientMixin
    return SafeArea(
      left: false,
      right: false,
      child: BlocBuilder<AudioBookCubit, AudioBookState>(
        buildWhen:
            (p, c) =>
                p.playlist != c.playlist ||
                p.currentTrackIndex != c.currentTrackIndex,
        builder: (context, state) {
          if (state.playlist.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            color: Colors.white,
            child: ReorderableListView.builder(
              itemCount: state.playlist.length,
              onReorder: (oldIndex, newIndex) {
                context.read<AudioBookCubit>().reorderPlaylist(
                  oldIndex,
                  newIndex,
                );
              },
              itemBuilder: (context, index) {
                final track = state.playlist[index];
                final bool isPlaying = state.currentTrackIndex == index;
                final bool paidLockedAudio =
                    !track.isFree &&
                    !context.read<UserCubit>().state.purchasedInfo!.isActive;

                return Container(
                  key: ValueKey(track.id),
                  color:
                      isPlaying ? const Color(0xFFF0FBFF) : Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      if (!isPlaying) {
                        context.read<AudioBookCubit>().skipToTrack(index);
                      }
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    title: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.grey[200],
                                ),
                                child:
                                    track.localThumbPath != null
                                        ? Image.asset(
                                          track.localThumbPath!,
                                          fit: BoxFit.cover,
                                        )
                                        : const SizedBox(),
                              ),
                              if (paidLockedAudio)
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.black.withValues(alpha: 0.4),
                                  ),
                                ),
                              if (paidLockedAudio)
                                SvgPicture.asset(
                                  'assets/icons/svg/vip.svg',
                                  width: 24,
                                  height: 24,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            track.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  isPlaying
                                      ? AppTheme.azureColor
                                      : AppTheme.textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      formatDuration(Duration(seconds: track.duration)),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:
                            isPlaying
                                ? AppTheme.azureColor
                                : const Color(0xFF98A2B3),
                      ),
                    ),
                    leading:
                        track.isDownloading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : isPlaying
                            ? LottieBuilder.asset(
                              'assets/lottie/audio.lottie',
                              decoder: customDecoder,
                              width: 24,
                              height: 24,
                            )
                            : ReorderableDragStartListener(
                              index: index,
                              child: const Icon(
                                Icons.drag_handle,
                                color: Color(0xFFEAECF0),
                                size: 24,
                              ),
                            ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
