import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void _onPressedStart(BuildContext context) {
    context.push(AppRoutePaths.chooseYearOfBirthOBD);
  }

  void _onPressedLogin(BuildContext context) {
    context.push(AppRoutePaths.login);
  }

  void _onPressedLanguage(BuildContext context) {
    context.push(AppRoutePaths.chooseLanguage);
  }

  void _onPressedActiveCode(BuildContext context) {
    context.push(AppRoutePaths.inputLicense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(color: AppTheme.textPrimaryColor),
                            ),
                            const SizedBox(height: Spacing.sm),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).translate('app.intro.desc'),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: Spacing.md),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
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
                      TextButton(
                        onPressed: () => _onPressedActiveCode(context),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).translate('app.intro.enter_activation_code'),
                        ),
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
    );
  }
}
