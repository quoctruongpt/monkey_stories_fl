import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/domain/usecases/tracking/onboarding/ms_ob_choose_account_type.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/screen_tracker.dart';

class IntroTracker {
  ClickType? clickType;
  DateTime timeStart = DateTime.now();
}

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final _introTracker = IntroTracker();

  void _onPressedStart(BuildContext context) {
    _introTracker.clickType = ClickType.startNow;
    context.push(AppRoutePaths.chooseYearOfBirthOBD);
  }

  void _onPressedLogin(BuildContext context) {
    _introTracker.clickType = ClickType.login;
    context.push(AppRoutePaths.login);
  }

  void _onPressedLanguage(BuildContext context) {
    _introTracker.clickType = ClickType.language;
    context.push(AppRoutePaths.chooseLanguage);
  }

  void _onPressedActiveCode(BuildContext context) {
    _introTracker.clickType = ClickType.activeCode;
    context.push(AppRoutePaths.inputLicense, extra: {'source': 'intro_screen'});
  }

  void _onTrackPush() {
    _introTracker.timeStart = DateTime.now();
  }

  void _onTrackExit() {
    sl<MsObChooseAccountTypeTrackingUsecase>().call(
      MsObChooseAccountTypeParams(
        tagName01: 'ms_flow_current',
        clickType: _introTracker.clickType,
        timeOnScreen:
            DateTime.now().difference(_introTracker.timeStart).inSeconds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTracker(
      routeName: AppRouteNames.intro,
      onTrackPush: _onTrackPush,
      onTrackExit: _onTrackExit,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 330),
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                heightFactor: 0.87,
                                child: Image.asset(
                                  'assets/images/intro_header.png',
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('app.intro.title'),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: Spacing.sm),
                              Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('app.intro.desc'),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: Spacing.md),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/rice_flower_left.png',
                                          height: 60,
                                          width: 29,
                                        ),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate('app.intro.user'),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium?.copyWith(
                                            color: AppTheme.textPrimaryColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Image.asset(
                                          'assets/images/rice_flower_right.png',
                                          height: 60,
                                          width: 29,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: Spacing.sm),
                                    Image.asset(
                                      'assets/images/kid_safe.png',
                                      height: 49,
                                      width: 174,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    child: Column(
                      children: [
                        AppButton.primary(
                          text: AppLocalizations.of(
                            context,
                          ).translate('app.intro.start_trial'),
                          onPressed: () => _onPressedStart(context),
                        ),
                        const SizedBox(height: Spacing.md),
                        AppButton.secondary(
                          text: AppLocalizations.of(
                            context,
                          ).translate('app.intro.login'),
                          onPressed: () => _onPressedLogin(context),
                        ),
                        const SizedBox(height: Spacing.md),
                        BlocBuilder<AppCubit, AppState>(
                          builder: (context, state) {
                            if (state.isHideSensitiveFeatures) {
                              return const SizedBox.shrink();
                            }

                            return TextButton(
                              onPressed: () => _onPressedActiveCode(context),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('app.intro.enter_activation_code'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 50,
                right: Spacing.md,
                child: BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    final language = Languages.getLanguageByCode(
                      context.read<AppCubit>().state.languageCode,
                    );

                    return OutlinedButton(
                      onPressed: () => _onPressedLanguage(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppTheme.backgroundColor,
                        padding: const EdgeInsets.all(Spacing.sm),
                      ),
                      child: Row(
                        children: [
                          Image.asset(language.flag, height: 24, width: 34),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            language.shortName,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.textSecondaryColor),
                          ),
                          const SizedBox(width: Spacing.sm),
                          const Icon(
                            Icons.settings_outlined,
                            color: AppTheme.textGrayLightColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
