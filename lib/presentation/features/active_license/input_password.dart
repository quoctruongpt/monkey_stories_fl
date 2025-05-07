import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';
import 'package:monkey_stories/presentation/widgets/active_license/popup_merge_lifetime_to_paid.dart';

class ActiveLicenseInputPassword extends StatefulWidget {
  const ActiveLicenseInputPassword({super.key});

  @override
  State<ActiveLicenseInputPassword> createState() =>
      _ActiveLicenseInputPasswordState();
}

class _ActiveLicenseInputPasswordState
    extends State<ActiveLicenseInputPassword> {
  @override
  void initState() {
    super.initState();
    context.read<ActiveLicenseCubit>().passwordChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen: (previous, current) {
              return (current.loginError != null &&
                  current.loginError != previous.loginError);
            },
            listener: (c, s) {
              _errorListener(c, s);
            },
          ),
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen:
                (previous, current) =>
                    current.showMergeLifetimeWarning ==
                        PositionShowWarning.inputPhone &&
                    current.showMergeLifetimeWarning !=
                        previous.showMergeLifetimeWarning,
            listener: _showMergeLifetimeWarningListener,
          ),
        ],
        child: BlocBuilder<ActiveLicenseCubit, ActiveLicenseState>(
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  appBar: const AppBarWidget(),
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.md,
                        right: Spacing.md,
                        bottom: Spacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate(
                              'app.active_license.input_password.title',
                            ),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),

                          const SizedBox(height: Spacing.sm),

                          Text(
                            '${state.phone.value.countryCode} ${state.phone.value.phoneNumber}',
                          ),

                          const SizedBox(height: Spacing.lg),

                          TextFieldWidget(
                            onChanged:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .passwordChanged,
                            labelText: AppLocalizations.of(context).translate(
                              'app.active_license.input_password.hint',
                            ),
                            errorText: AppLocalizations.of(
                              context,
                            ).translate(state.password.displayError),
                          ),

                          const SizedBox(height: Spacing.lg),

                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.push(
                                  AppRoutePaths.activeLicenseInputOtp,
                                );
                                context.read<ActiveLicenseCubit>().sendOtp();
                              },
                              child: Text(
                                AppLocalizations.of(context).translate(
                                  'app.active_license.input_password.otp',
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          AppButton.primary(
                            text: AppLocalizations.of(
                              context,
                            ).translate('app.active_license.finish'),
                            onPressed: () {
                              context
                                  .read<ActiveLicenseCubit>()
                                  .activateByPhoneExist(true);
                            },
                            disabled: state.password.isNotValid,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                state.isLoading
                    ? const LoadingOverlay()
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _errorListener(BuildContext context, ActiveLicenseState state) {
    if (state.loginError != null) {
      showCustomNoticeDialog(
        context: context,
        titleText: AppLocalizations.of(
          context,
        ).translate('app.active_license.error'),
        messageText: state.loginError ?? '',
        imageAsset: 'assets/images/monkey_confused.png',
        primaryActionText: AppLocalizations.of(
          context,
        ).translate('app.active_license.close'),
        onPrimaryAction: () {
          context.pop();
          context.read<ActiveLicenseCubit>().clearLoginError();
        },
      );
    }
  }

  void _showMergeLifetimeWarningListener(
    BuildContext context,
    ActiveLicenseState state,
  ) {
    showPopupWarningMergeLifetimeToPaid(
      context: context,
      onContinue: () {
        context.read<ActiveLicenseCubit>().activateByPhoneExist(false);
        context.read<ActiveLicenseCubit>().closeMergeLifetimeWarning();
        context.pop();
      },
      onCancel: () {
        context.read<ActiveLicenseCubit>().closeMergeLifetimeWarning();
        context.pop();
      },
    );
  }
}
