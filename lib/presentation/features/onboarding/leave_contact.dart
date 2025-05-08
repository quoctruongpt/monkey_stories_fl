import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/leave_contact/leave_contact_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_field/phone_input_widget.dart';

class LeaveContact extends StatelessWidget {
  const LeaveContact({super.key});

  void _onSuccess(BuildContext context) {
    context.go(AppRoutePaths.home);
  }

  void _onError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _onSkip(BuildContext context) {
    context.go(AppRoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LeaveContactCubit>(),
      child: BlocListener<LeaveContactCubit, LeaveContactState>(
        listenWhen:
            (previous, current) =>
                previous.isSuccess != current.isSuccess ||
                previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.isSuccess) {
            _onSuccess(context);
          } else if (state.errorMessage != null) {
            _onError(context, state.errorMessage ?? '');
          }
        },
        child: KeyboardDismisser(
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBarWidget(
                  actions: [
                    TextButton(
                      onPressed: () {
                        _onSkip(context);
                      },
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

                            BlocBuilder<LeaveContactCubit, LeaveContactState>(
                              builder: (context, state) {
                                return PhoneInputField(
                                  onChanged: (value) {
                                    context
                                        .read<LeaveContactCubit>()
                                        .phoneChanged(value);
                                  },
                                  onCountryChange: (value) {
                                    context
                                        .read<LeaveContactCubit>()
                                        .countryCodeChanged(value);
                                  },
                                  onCountryInit: (value) {
                                    context
                                        .read<LeaveContactCubit>()
                                        .countryCodeChanged(value);
                                  },
                                  errorText: AppLocalizations.of(
                                    context,
                                  ).translate(state.phone.displayError),
                                  isPhoneValid: state.phone.isValid,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      BlocBuilder<LeaveContactCubit, LeaveContactState>(
                        builder: (context, state) {
                          return AppButton.primary(
                            text: AppLocalizations.of(
                              context,
                            ).translate('app.onboarding.continue'),
                            onPressed: () {
                              context.read<LeaveContactCubit>().submit();
                            },
                            disabled:
                                state.isSubmitting || !state.phone.isValid,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              BlocBuilder<LeaveContactCubit, LeaveContactState>(
                builder: (context, state) {
                  return state.isSubmitting
                      ? const LoadingOverlay()
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
