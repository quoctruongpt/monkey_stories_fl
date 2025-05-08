import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/constants/level.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class SuggestedLevel extends StatelessWidget {
  const SuggestedLevel({super.key});

  void _onContinuePressed(BuildContext context) {
    context.push(AppRoutePaths.onboardLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final suggestedLearningPhase = getSuggestedLearningPhase(
            state.levelId!,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: Spacing.lg),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        ).translate('app.suggest_level.title'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.azureColor,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context).translate('app.suggest_level.suggest', params: {'number': suggestedLearningPhase.toString()})} - ${AppLocalizations.of(context).translate(phase[suggestedLearningPhase! - 1].name)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.orangeColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate(
                            phase[suggestedLearningPhase - 1].description,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          phase.length,
                          (index) => _LevelColumnWidget(
                            level: index + 1,
                            isSelected: index == suggestedLearningPhase - 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  child: AppButton.primary(
                    text: AppLocalizations.of(
                      context,
                    ).translate('app.onboarding.continue'),
                    onPressed: () => _onContinuePressed(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

int getSuggestedLearningPhase(int levelId) {
  switch (levelId) {
    case LevelId.a:
      return 1;
    case LevelId.b:
      return 2;
    default:
      return 3;
  }
}

class _LevelColumnWidget extends StatefulWidget {
  const _LevelColumnWidget({required this.level, required this.isSelected});

  final int level;
  final bool isSelected;

  @override
  State<_LevelColumnWidget> createState() => _LevelColumnWidgetState();
}

class _LevelColumnWidgetState extends State<_LevelColumnWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    if (widget.isSelected) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(_LevelColumnWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        clipBehavior: Clip.none,
        child: Column(
          children: [
            if (widget.isSelected)
              Container(
                clipBehavior: Clip.none,
                width: 80,
                height: 120,
                alignment: Alignment.center,
                child: OverflowBox(
                  minWidth: 121,
                  maxWidth: 121,
                  minHeight: 120,
                  maxHeight: 120,
                  child: Image.asset(
                    'assets/images/max_flag.png',
                    width: 121,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Container(
              height: 120.0 + (widget.level * 60),
              width: 80.0,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      widget.isSelected
                          ? [
                            const Color(0xFFFFAE00),
                            Colors.white,
                          ] // Màu mờ dần khi được chọn
                          : [
                            const Color(0xFF63D3FF),
                            Colors.white,
                          ], // Màu mờ dần mặc định
                  stops: [0.2, 1 - widget.level * 0.05],
                ),
              ),
              child: Text(
                '${widget.level}',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 80,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).translate(phase[widget.level - 1].name),
                  style: TextStyle(
                    color: widget.isSelected ? Colors.orange : Colors.lightBlue,
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: widget.isSelected ? 16 : 12,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
