import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';
import 'package:monkey_stories/presentation/widgets/text_field/phone_input_widget.dart';

class LeaveContact extends StatelessWidget {
  const LeaveContact({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBarWidget(
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(
                  context,
                ).translate('app.leave_contact.skip'),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.only(
            left: Spacing.md,
            right: Spacing.md,
            bottom: Spacing.lg,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CreateProfileHeader(
                      title: AppLocalizations.of(
                        context,
                      ).translate('app.leave_contact.title'),
                    ),

                    const SizedBox(height: Spacing.md),

                    const PhoneInputField(),
                  ],
                ),
              ),

              AppButton.primary(
                text: AppLocalizations.of(
                  context,
                ).translate('app.onboarding.continue'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
