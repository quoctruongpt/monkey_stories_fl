import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/audio_book/audio_book_cubit.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/footer.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/lyrics_view.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/thumb_audio.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';

class AudioBookPage extends StatelessWidget {
  const AudioBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AudioBookCubit>()..loadAudioBook(),
      child: const AudioBook(),
    );
  }
}

class AudioBook extends StatelessWidget {
  const AudioBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/audio_book_bg.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: SvgPicture.asset('assets/icons/svg/game_back.svg'),
          ),
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: Spacing.md,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ThumbAudio(),
                SizedBox(width: Spacing.lg),
                Expanded(child: LyricsView()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const Footer(),
      ),
    );
  }
}
