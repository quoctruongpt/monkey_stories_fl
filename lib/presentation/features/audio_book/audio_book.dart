import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/audio_book/audio_book_cubit.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/footer.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/lyrics_view.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/playlist_view.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/thumb_audio.dart';
import 'package:monkey_stories/presentation/features/audio_book/widgets/timer_dropdown.dart';
import 'package:monkey_stories/presentation/bloc/playlist/playlist_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/dialogs/unlock_lesson_dialog.dart';
import 'package:monkey_stories/presentation/widgets/parent_verify.dart';

class AudioBookPage extends StatefulWidget {
  const AudioBookPage({super.key, this.audioSelectedId});

  final int? audioSelectedId;

  @override
  State<AudioBookPage> createState() => _AudioBookPageState();
}

class _AudioBookPageState extends State<AudioBookPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the playlist from the shared PlaylistCubit
    final playlist = context.read<PlaylistCubit>().state.playlist;

    return BlocProvider(
      create:
          (context) =>
              sl<AudioBookCubit>()..loadPlaylist(
                playlist: playlist,
                audioSelectedId: widget.audioSelectedId,
              ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AudioBookCubit, AudioBookState>(
            listenWhen: (p, c) => p.currentViewIndex != c.currentViewIndex,
            listener: (context, state) {
              // Programmatically switch tabs
              _tabController.animateTo(state.currentViewIndex);
            },
          ),
          BlocListener<AudioBookCubit, AudioBookState>(
            listenWhen: (p, c) => p.shouldNavigateBack != c.shouldNavigateBack,
            listener: (context, state) {
              if (state.shouldNavigateBack) {
                context.pop();
              }
            },
          ),
          BlocListener<AudioBookCubit, AudioBookState>(
            listenWhen:
                (p, c) => p.showBuyToUnlockPopup != c.showBuyToUnlockPopup,
            listener: (context, state) {
              if (state.showBuyToUnlockPopup) {
                showUnlockLessonDialog(
                  context: context,
                  onUnlock: () {
                    context.pop();
                    context.read<AudioBookCubit>().closeBuyToUnlockPopup();
                    showVerifyDialog(
                      context: context,
                      onSuccess: () {
                        context.push(AppRoutePaths.purchased);
                      },
                    );
                  },
                  onClose: () {
                    context.pop();
                    context.read<AudioBookCubit>().closeBuyToUnlockPopup();
                  },
                );
              }
            },
          ),
        ],
        child: Container(
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
            appBar: _buildAppBar(context),
            body: TabBarView(
              // Disable manual swiping between tabs
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [NowPlayingView(), PlaylistView()],
            ),
            bottomNavigationBar: const Footer(),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      primary: false,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: SvgPicture.asset('assets/icons/svg/game_back.svg'),
                ),
                const SizedBox(width: 16),
                const TimerDropdown(),
              ],
            ),

            // Ẩn tự động chuyển bài nếu chưa mua
            context.read<UserCubit>().state.purchasedInfo!.isActive
                ? Row(
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('Tự động chuyển bài'),
                      style: const TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<AudioBookCubit, AudioBookState>(
                      builder: (context, state) {
                        return Switch(
                          value: state.isAutoplayEnabled,
                          onChanged: (value) {
                            context.read<AudioBookCubit>().setAutoplay(value);
                          },
                          activeTrackColor: AppTheme.azureColor,
                          inactiveTrackColor: const Color(0xFFB3E8FF),
                          thumbColor: MaterialStateProperty.all(Colors.white),
                          trackOutlineColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          overlayColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          splashRadius: 0,
                        );
                      },
                    ),
                  ],
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

// Represents the main "Now Playing" screen
class NowPlayingView extends StatefulWidget {
  const NowPlayingView({super.key});

  @override
  State<NowPlayingView> createState() => _NowPlayingViewState();
}

class _NowPlayingViewState extends State<NowPlayingView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important for AutomaticKeepAliveClientMixin
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<AudioBookCubit, AudioBookState>(
              buildWhen:
                  (p, c) =>
                      p.currentTrackIndex != c.currentTrackIndex ||
                      p.playlist != c.playlist,
              builder: (context, state) {
                final currentTrack =
                    state.playlist.isNotEmpty
                        ? state.playlist[state.currentTrackIndex]
                        : null;

                return ThumbAudio(track: currentTrack);
              },
            ),
            const SizedBox(width: 24),
            const Expanded(child: LyricsView()),
          ],
        ),
      ),
    );
  }
}
