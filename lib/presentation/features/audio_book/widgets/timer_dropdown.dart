import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/audio_book/audio_book_cubit.dart';

class TimerDropdown extends StatelessWidget {
  const TimerDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBookCubit, AudioBookState>(
      buildWhen:
          (p, c) =>
              p.isAutoplayEnabled != c.isAutoplayEnabled ||
              p.timerDuration != c.timerDuration,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child:
              state.isAutoplayEnabled
                  ? _buildVisibleDropdown(context, state)
                  : const SizedBox.shrink(key: ValueKey('timer_hidden')),
        );
      },
    );
  }

  Widget _buildVisibleDropdown(BuildContext context, AudioBookState state) {
    final timerOptions = [1, 20, 30, 45, 60];
    final currentMinutes = state.timerDuration?.inMinutes ?? 30;

    String formatDuration(Duration d) {
      return AppLocalizations.of(context).translate(
        'app.audio_book.minutes',
        params: {'number': d.inMinutes.toString().padLeft(2, '0')},
      );
    }

    return PopupMenuButton<int>(
      key: const ValueKey('timer_visible'),
      onSelected: (int minutes) {
        context.read<AudioBookCubit>().setTimer(Duration(minutes: minutes));
      },
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      offset: const Offset(-20, 8.0),
      itemBuilder: (BuildContext context) {
        return timerOptions.map((int minutes) {
          final isSelected = minutes == currentMinutes;
          return PopupMenuItem<int>(
            value: minutes,
            child: Container(
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFF0FBFF) : Colors.transparent,
                borderRadius: BorderRadius.circular(40.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 24,
              ),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context).translate(
                  'app.audio_book.minutes',
                  params: {'number': minutes.toString()},
                ),
                style: const TextStyle(
                  color: AppTheme.azureColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.azureColor, width: 2),
          borderRadius: BorderRadius.circular(90),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.timer_outlined,
              color: AppTheme.azureColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              formatDuration(state.timerDuration ?? Duration.zero),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppTheme.azureColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.azureColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
