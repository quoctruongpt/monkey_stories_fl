import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = context.read<AppCubit>().state.languageCode;
  }

  void _onLanguageSelected(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  void _onConfirm() {
    context.read<AppCubit>().changeLanguage(selectedLanguage!);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(
          context,
        ).translate('app.choose_language.title'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Spacing.md,
            right: Spacing.md,
            bottom: Spacing.lg,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: Languages.supportedLanguages.length,

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.md),
                      child: OutlinedButton(
                        onPressed:
                            () => _onLanguageSelected(
                              Languages.supportedLanguages[index].code,
                            ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.sm,
                          ),
                          side: BorderSide(
                            color:
                                selectedLanguage ==
                                        Languages.supportedLanguages[index].code
                                    ? AppTheme.primaryColor
                                    : AppTheme.buttonPrimaryDisabledBackground,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Image.asset(
                                    Languages.supportedLanguages[index].flag,
                                    width: 70,
                                    height: 50,
                                  ),
                                  const SizedBox(width: Spacing.md),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Languages
                                            .supportedLanguages[index]
                                            .description,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: AppTheme.textGrayLightColor,
                                        ),
                                      ),
                                      Text(
                                        Languages
                                            .supportedLanguages[index]
                                            .localName,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.displaySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            if (selectedLanguage ==
                                Languages.supportedLanguages[index].code)
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return AppButton.primary(
                    text: AppLocalizations.of(
                      context,
                    ).translate('app.choose_language.confirm'),
                    onPressed: _onConfirm,
                    disabled:
                        selectedLanguage == null ||
                        selectedLanguage == state.languageCode,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
