import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/select_bottom_sheet.dart';

class GeneralSettingScreen extends StatelessWidget {
  const GeneralSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context).translate('Cài đặt chung'),
      ),

      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacing.md),
        child: Column(
          children: [
            ChangeLanguage(),
            Divider(color: AppTheme.skyLightColor),

            SizedBox(height: Spacing.sm),
            ChangeBackgroundMusic(),
            SizedBox(height: Spacing.sm),
            Divider(color: AppTheme.skyLightColor),

            SizedBox(height: Spacing.md),
            ChangeNotification(),
            SizedBox(height: Spacing.sm),
            Divider(color: AppTheme.skyLightColor),

            SizedBox(height: Spacing.md),
            VersionApp(),
            SizedBox(height: Spacing.md),
            Divider(color: AppTheme.skyLightColor),
          ],
        ),
      ),
    );
  }
}

class VersionApp extends StatelessWidget {
  const VersionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/svg/devices.svg', width: 24, height: 24),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Text(AppLocalizations.of(context).translate('Phiên bản')),
        ),
        BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Text(
              state.appVersion,
              style: const TextStyle(color: AppTheme.textGrayColor),
            );
          },
        ),
      ],
    );
  }
}

class ChangeBackgroundMusic extends StatelessWidget {
  const ChangeBackgroundMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/volume_up.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(AppLocalizations.of(context).translate('Nhạc nền')),
            ),
            Switch(
              value: state.isBackgroundMusicEnabled,
              onChanged: (value) {
                context.read<AppCubit>().toggleBackgroundMusic();
              },
              activeTrackColor: AppTheme.successColor,
              inactiveThumbColor: AppTheme.textSecondaryColor,
              trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.successColor;
                }
                return AppTheme.textSecondaryColor;
              }),
            ),
          ],
        );
      },
    );
  }
}

class ChangeNotification extends StatelessWidget {
  const ChangeNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/notification.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(AppLocalizations.of(context).translate('Thông báo')),
            ),
            Switch(
              value: state.isNotificationEnabled,
              onChanged: (value) {
                context.read<AppCubit>().toggleNotification();
              },
              activeTrackColor: AppTheme.successColor,
              inactiveThumbColor: AppTheme.textSecondaryColor,
              trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.successColor;
                }
                return AppTheme.textSecondaryColor;
              }),
            ),
          ],
        );
      },
    );
  }
}

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SelectBottomSheet<Language>(
          hintText: AppLocalizations.of(context).translate('Chọn ngôn ngữ'),
          title: AppLocalizations.of(context).translate('Ngôn ngữ hiển thị'),
          leading: SvgPicture.asset(
            'assets/icons/svg/language.svg',
            width: 24,
            height: 24,
          ),
          currentLabel: AppLocalizations.of(
            context,
          ).translate(state.languageCode),
          items: Languages.supportedLanguages,
          onChange: (item) {
            context.read<AppCubit>().changeLanguage(item.code);
          },
          itemWidget:
              (item) => Container(
                decoration: BoxDecoration(
                  color:
                      item.code == state.languageCode
                          ? AppTheme.buttonPrimaryDisabledBackground
                          : null,
                  borderRadius: BorderRadius.circular(Spacing.sm),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.sm,
                  horizontal: Spacing.md,
                ),
                child: Row(
                  children: [
                    Image.asset(item.flag, width: 45, height: 32),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).translate(item.code),
                      ),
                    ),
                    (item.code == state.languageCode)
                        ? const Icon(
                          Icons.check_circle,
                          color: AppTheme.successColor,
                        )
                        : const Icon(
                          Icons.radio_button_unchecked,
                          color: AppTheme.textSecondaryColor,
                        ),
                  ],
                ),
              ),
        );
      },
    );
  }
}
