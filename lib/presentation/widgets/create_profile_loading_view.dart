import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/features/create_profile/create_profile_loading.dart';

class CreateProfileLoadingView extends StatelessWidget {
  const CreateProfileLoadingView({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
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
                  value: progress,
                  strokeWidth: 24,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppTheme.skyLightColor,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
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
          active: progress >= 0.25,
        ),
        CreateProfileLoadingItem(
          title: AppLocalizations.of(
            context,
          ).translate('create_profile.loading.item.2'),
          active: progress >= 0.5,
        ),
        CreateProfileLoadingItem(
          title: AppLocalizations.of(
            context,
          ).translate('create_profile.loading.item.3'),
          active: progress >= 0.75,
        ),
      ],
    );
  }
}
