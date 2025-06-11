import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/audio_book/audio_book_cubit.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  // Local state to manage slider value during drag
  Duration? _dragValue;

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBookCubit, AudioBookState>(
      builder: (context, state) {
        final cubit = context.read<AudioBookCubit>();
        final status = state.status;
        final currentPosition = _dragValue ?? state.currentPosition;
        final totalDuration = state.totalDuration;
        final isPlaying = status == AudioPlayerStatus.playing;

        return SafeArea(
          bottom: false,
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
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icons/svg/previous.svg',
                        width: 36,
                        height: 36,
                      ),
                    ),
                    IconButton(
                      onPressed: () => isPlaying ? cubit.pause() : cubit.play(),
                      icon: SvgPicture.asset(
                        isPlaying
                            ? 'assets/icons/svg/pause.svg'
                            : 'assets/icons/svg/play.svg',
                        width: 36,
                        height: 36,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icons/svg/next.svg',
                        width: 36,
                        height: 36,
                      ),
                    ),
                    const SizedBox(width: Spacing.lg),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(
                        'assets/images/purchased.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    const Expanded(child: Text("Charlotte's Web", maxLines: 1)),
                    const SizedBox(width: Spacing.md),
                    Text(
                      '${_formatDuration(currentPosition)}/${_formatDuration(totalDuration)}',
                    ),
                    const SizedBox(width: Spacing.md),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: AppTheme.azureColor),
                        padding: const EdgeInsets.all(10),
                        minimumSize: const Size(44, 44),
                      ),
                      child: const Icon(
                        Icons.format_list_bulleted_rounded,
                        size: 24,
                        color: AppTheme.azureColor,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -24,
                left: 0,
                right: 0,
                child: SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                    inactiveTrackColor: Color(0xFFFAFAFA),
                    activeTrackColor: AppTheme.azureColor,
                    thumbColor: AppTheme.azureColor,
                  ),
                  child: Slider(
                    value: currentPosition.inMilliseconds.toDouble().clamp(
                      0.0,
                      totalDuration.inMilliseconds.toDouble(),
                    ),
                    max: totalDuration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = Duration(milliseconds: value.round());
                      });
                    },
                    onChangeEnd: (value) {
                      cubit.seek(Duration(milliseconds: value.round()));
                      setState(() {
                        _dragValue = null;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
