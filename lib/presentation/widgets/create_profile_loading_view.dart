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
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: AppTheme.azureColor),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 80),

        Stack(
          children: [
            Image.asset(
              'assets/images/obd_loading.png',
              width: 308,
              height: 360,
              fit: BoxFit.cover,
            ),

            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF82D9FF),
                    minHeight: 11,
                    borderRadius: BorderRadius.circular(100),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 80),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          child: Column(
            children: [
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
          ),
        ),
      ],
    );
  }
}
