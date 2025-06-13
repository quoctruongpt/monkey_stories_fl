import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/number.dart';
import 'package:monkey_stories/presentation/bloc/audio_book/audio_book_cubit.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  // Local state to manage slider value during drag
  Duration? _dragValue;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBookCubit, AudioBookState>(
      buildWhen:
          (prev, curr) =>
              prev.status != curr.status ||
              prev.currentPosition != curr.currentPosition ||
              prev.totalDuration != curr.totalDuration ||
              prev.currentTrackIndex != curr.currentTrackIndex ||
              prev.isAutoplayEnabled != curr.isAutoplayEnabled ||
              prev.currentViewIndex != curr.currentViewIndex,
      builder: (context, state) {
        final cubit = context.read<AudioBookCubit>();
        final status = state.status;
        final currentPosition = _dragValue ?? state.currentPosition;

        final currentTrack =
            state.playlist.isNotEmpty
                ? state.playlist[state.currentTrackIndex]
                : null;
        final totalDuration = state.totalDuration;

        final isPlaying = status == AudioPlayerStatus.playing;
        final hasPrevious =
            state.currentTrackIndex > 0 &&
            state.playlist[state.currentTrackIndex - 1].isDownloaded;
        final hasNext =
            state.currentTrackIndex < state.playlist.length - 1 &&
            state.playlist[state.currentTrackIndex + 1].isDownloaded;

        return Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            right: false,
            left: false,

            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.sm,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/svg/previous.svg',
                          color: hasPrevious ? null : Colors.grey,
                        ),
                        onPressed: hasPrevious ? cubit.previous : null,
                      ),
                      IconButton(
                        onPressed:
                            () => isPlaying ? cubit.pause() : cubit.play(),
                        icon: SvgPicture.asset(
                          isPlaying
                              ? 'assets/icons/svg/pause.svg'
                              : 'assets/icons/svg/play.svg',
                          width: 36,
                          height: 36,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/svg/next.svg',
                          color: hasNext ? null : Colors.grey,
                        ),
                        onPressed: hasNext ? cubit.next : null,
                      ),
                      const SizedBox(width: Spacing.lg),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey[200], // Placeholder color
                        ),
                        child:
                            currentTrack?.localThumbPath != null
                                ? Image.asset(
                                  currentTrack!.localThumbPath!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                )
                                : const SizedBox(width: 44, height: 44),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Text(
                          currentTrack?.name ?? "No track",
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Text(
                        '${formatDuration(currentPosition)}/${formatDuration(totalDuration)}',
                      ),
                      const SizedBox(width: Spacing.md),
                      OutlinedButton(
                        onPressed: () {
                          context.read<AudioBookCubit>().togglePlaylistView();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: AppTheme.azureColor,
                            width: state.currentViewIndex == 0 ? 1 : 0,
                          ),
                          padding: const EdgeInsets.all(10),
                          minimumSize: const Size(44, 44),
                          backgroundColor:
                              state.currentViewIndex == 0
                                  ? Colors.transparent
                                  : AppTheme.azureColor,
                        ),
                        child: Icon(
                          Icons.format_list_bulleted_rounded,
                          size: 24,
                          color:
                              state.currentViewIndex == 0
                                  ? AppTheme.azureColor
                                  : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -12,
                  left: 0,
                  right: 0,
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 4,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 10.0,
                      ),
                      inactiveTrackColor: Color(0xFFFAFAFA),
                      activeTrackColor: AppTheme.azureColor,
                      thumbColor: AppTheme.azureColor,
                      trackShape: RectangularSliderTrackShape(),
                    ),
                    child: Slider(
                      value: currentPosition.inMilliseconds.toDouble().clamp(
                        0.0,
                        totalDuration.inMilliseconds.toDouble(),
                      ),
                      padding: EdgeInsets.zero,
                      max: totalDuration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        final newPosition = Duration(
                          milliseconds: value.round(),
                        );
                        setState(() {
                          _dragValue = newPosition;
                        });
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 200),
                          () {
                            context.read<AudioBookCubit>().seek(newPosition);
                          },
                        );
                      },
                      onChangeEnd: (value) {
                        _debounce?.cancel();
                        final newPosition = Duration(
                          milliseconds: value.round(),
                        );
                        context.read<AudioBookCubit>().seek(newPosition);
                        setState(() {
                          _dragValue = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
