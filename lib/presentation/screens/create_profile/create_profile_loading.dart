import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/create_profile_loading/create_profile_loading_cubit.dart';
import 'package:monkey_stories/presentation/widgets/notice_dialog.dart';

class CreateProfileLoadingScreen extends StatelessWidget {
  const CreateProfileLoadingScreen({
    super.key,
    required this.name,
    required this.yearOfBirth,
    required this.levelId,
  });

  final String name;
  final int yearOfBirth;
  final int levelId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateProfileLoadingCubit>(),
      child: CreateProfileLoading(
        name: name,
        yearOfBirth: yearOfBirth,
        levelId: levelId,
      ),
    );
  }
}

class CreateProfileLoading extends StatefulWidget {
  const CreateProfileLoading({
    super.key,
    required this.name,
    required this.yearOfBirth,
    required this.levelId,
  });

  final String name;
  final int yearOfBirth;
  final int levelId;

  @override
  State<CreateProfileLoading> createState() => _CreateProfileLoadingState();
}

class _CreateProfileLoadingState extends State<CreateProfileLoading> {
  @override
  void initState() {
    super.initState();
    // Gọi startLoading khi màn hình được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateProfileLoadingCubit>().startLoading(
        widget.name,
        widget.yearOfBirth,
      );
    });
  }

  void _onSuccess() {
    context.go(AppRoutePaths.home);
  }

  void _onError(String error) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('create_profile.loading.error.title'),
      messageText: error,
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('create_profile.loading.error.act'),
      onPrimaryAction: () {
        context.go(AppRoutePaths.home);
        context.pop();
      },
      isCloseable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: BlocListener<
            CreateProfileLoadingCubit,
            CreateProfileLoadingState
          >(
            listenWhen:
                (previous, current) =>
                    previous.callApiProfileError != current.callApiProfileError,
            listener: (context, state) {
              _onError(state.callApiProfileError!);
            },
            child: BlocConsumer<
              CreateProfileLoadingCubit,
              CreateProfileLoadingState
            >(
              listener: (context, state) {
                if (state.progress >= 1) {
                  _onSuccess();
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).translate('create_profile.loading.title'),
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 80),

                    SizedBox(
                      height: 216,
                      width: 216,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: state.progress,
                              strokeWidth: 24,
                              strokeCap: StrokeCap.round,
                              backgroundColor: AppTheme.skyLightColor,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            '${(state.progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),

                    CreateProfileLoadingItem(
                      title: AppLocalizations.of(
                        context,
                      ).translate('create_profile.loading.item.1'),
                      active: state.progress >= 0.25,
                    ),
                    CreateProfileLoadingItem(
                      title: AppLocalizations.of(
                        context,
                      ).translate('create_profile.loading.item.2'),
                      active: state.progress >= 0.5,
                    ),
                    CreateProfileLoadingItem(
                      title: AppLocalizations.of(
                        context,
                      ).translate('create_profile.loading.item.3'),
                      active: state.progress >= 0.75,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CreateProfileLoadingItem extends StatefulWidget {
  const CreateProfileLoadingItem({
    super.key,
    required this.title,
    this.active = false,
  });

  final String title;
  final bool active;

  @override
  State<CreateProfileLoadingItem> createState() =>
      _CreateProfileLoadingItemState();
}

class _CreateProfileLoadingItemState extends State<CreateProfileLoadingItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _previousActive = false;

  @override
  void initState() {
    super.initState();
    _previousActive = widget.active;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 50,
      ),
    ]).animate(_controller);

    // Kích hoạt animation nếu active = true ngay từ đầu
    if (widget.active) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CreateProfileLoadingItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kích hoạt animation khi active thay đổi từ false sang true
    if (widget.active && !_previousActive) {
      _controller.reset();
      _controller.forward();
    }

    _previousActive = widget.active;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Row(
        children: [
          Icon(
            widget.active ? Icons.check_circle : Icons.check_circle_outline,
            color:
                widget.active ? AppTheme.primaryColor : AppTheme.textGrayColor,
          ),
          const SizedBox(width: Spacing.sm),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  widget.active
                      ? AppTheme.primaryColor
                      : AppTheme.textGrayColor,
            ),
          ),
          const SizedBox(width: Spacing.sm),
        ],
      ),
    );
  }
}
