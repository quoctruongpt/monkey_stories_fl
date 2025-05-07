import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/validators/otp.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:monkey_stories/presentation/widgets/active_license/popup_merge_lifetime_to_paid.dart';

class ActiveLicenseInputOtp extends StatefulWidget {
  const ActiveLicenseInputOtp({super.key});

  @override
  State<ActiveLicenseInputOtp> createState() => _ActiveLicenseInputOtpState();
}

class _ActiveLicenseInputOtpState extends State<ActiveLicenseInputOtp> {
  @override
  void initState() {
    super.initState();
    context.read<ActiveLicenseCubit>().otpChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen: (previous, current) {
              return (current.sendOtpError != null &&
                  current.sendOtpError != previous.sendOtpError);
            },
            listener: (c, s) {
              _errorListener(c, s);
            },
          ),
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen:
                (previous, current) =>
                    current.showMergeLifetimeWarning ==
                        PositionShowWarning.inputOtp &&
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
                            AppLocalizations.of(
                              context,
                            ).translate('app.active_license.input_otp.title'),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),

                          const SizedBox(height: Spacing.sm),

                          Text(
                            AppLocalizations.of(context).translate(
                              'app.active_license.input_otp.phone_number',
                            ),
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),

                          Text(
                            '${state.phone.value.countryCode} ${state.phone.value.phoneNumber}',
                          ),

                          const SizedBox(height: Spacing.lg),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.lg,
                            ),
                            child: PinCodeTextField(
                              appContext: context,
                              length: otpLength,
                              onChanged:
                                  context.read<ActiveLicenseCubit>().otpChanged,
                              textStyle:
                                  Theme.of(context).textTheme.displayMedium,
                              keyboardType: TextInputType.number,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(12),
                                fieldHeight: 68,
                                fieldWidth: 63,
                                activeColor: AppTheme.textGrayLightColor,
                                inactiveColor: AppTheme.textGrayLightColor,
                                inactiveFillColor: AppTheme.textGrayLightColor,
                                activeFillColor: AppTheme.textGrayLightColor,
                                selectedColor: AppTheme.textGrayLightColor,
                                selectedFillColor: AppTheme.textGrayLightColor,
                                borderWidth: 1,
                                errorBorderColor: AppTheme.errorColor,
                              ),
                            ),
                          ),

                          Center(
                            child:
                                state.otpResendTime == 0
                                    ? TextButton(
                                      onPressed: () {
                                        context
                                            .read<ActiveLicenseCubit>()
                                            .sendOtp();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context).translate(
                                          'app.active_license.input_otp.resend',
                                        ),
                                      ),
                                    )
                                    : null,
                          ),

                          const Spacer(),

                          AppButton.primary(
                            text: AppLocalizations.of(
                              context,
                            ).translate('app.active_license.finish'),
                            onPressed: () {
                              context.read<ActiveLicenseCubit>().verifyOtp(
                                true,
                              );
                            },
                            disabled: state.otp.isNotValid,
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
    if (state.sendOtpError != null) {
      showCustomNoticeDialog(
        context: context,
        titleText: AppLocalizations.of(
          context,
        ).translate('app.active_license.error'),
        messageText: state.sendOtpError ?? '',
        imageAsset: 'assets/images/monkey_confused.png',
        primaryActionText: AppLocalizations.of(
          context,
        ).translate('app.active_license.close'),
        onPrimaryAction: () {
          context.pop();
          context.read<ActiveLicenseCubit>().clearSendOtpError();
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
