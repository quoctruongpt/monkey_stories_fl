import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/widgets/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/notice_dialog.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

const length = 4;

class InputOtpFp extends StatefulWidget {
  const InputOtpFp({super.key});

  @override
  State<InputOtpFp> createState() => _InputOtpFpState();
}

class _InputOtpFpState extends State<InputOtpFp> {
  ForgotPasswordCubit? _forgotPasswordCubit;

  Future<void> _onConfirmPressed(BuildContext context) async {
    final canVerifyOtp = context.read<ForgotPasswordCubit>().canVerifyOtp();
    if (canVerifyOtp) {
      final isSuccess = await context.read<ForgotPasswordCubit>().verifyOtp();
      if (isSuccess) {
        context.pushNamed(AppRouteNames.inputNewPasswordFp);
      }
    } else {
      showCustomNoticeDialog(
        context: context,
        titleText: AppLocalizations.of(context).translate("Thông báo"),
        messageText: AppLocalizations.of(context).translate(
          "Bạn đã nhập sai mã OTP quá 5 lần. Vui lòng quay trở lại sau 5 phút.",
        ),
        imageAsset: 'assets/images/max_5m.png',
        primaryActionText: AppLocalizations.of(
          context,
        ).translate("Tôi đã hiểu"),
        onPrimaryAction: () {
          context.pop();
        },
      );
    }
  }

  void _onResendOtpPressed(BuildContext context) {
    context.read<ForgotPasswordCubit>().sendOtp();
  }

  @override
  void initState() {
    super.initState();
    _forgotPasswordCubit = context.read<ForgotPasswordCubit>();
  }

  @override
  void dispose() {
    _forgotPasswordCubit?.clearOtp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: const AppBarWidget(),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Spacing.md,
            right: Spacing.md,
            bottom: Spacing.lg,
          ),
          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/monkey_message.png',
                            width: 158,
                            height: 150,
                          ),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            AppLocalizations.of(
                              context,
                            ).translate('Xác nhận OTP'),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: Spacing.sm),

                          Text(
                            AppLocalizations.of(context).translate(
                              'Monkey đã gửi mã OTP đến số điện thoại ${state.phone.value.countryCode} ${state.phone.value.phoneNumber}',
                            ),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.textSecondaryColor),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: Spacing.xxl),

                          PinCodeTextField(
                            appContext: context,
                            length: length,
                            onChanged:
                                context.read<ForgotPasswordCubit>().otpChanged,
                            textStyle: Theme.of(context).textTheme.titleMedium,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12),
                              fieldHeight: 86,
                              fieldWidth: 83,
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

                          Text(
                            state.otpError ?? '',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppTheme.errorColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppButton.primary(
                    text: AppLocalizations.of(context).translate('Xác nhận'),
                    onPressed: () => _onConfirmPressed(context),
                    disabled: !state.otp.isValid || state.isLoading,
                    isLoading: state.isLoading,
                  ),
                  TextButton(
                    onPressed:
                        state.otpResendTime == 0
                            ? () => _onResendOtpPressed(context)
                            : null,
                    child: Text(
                      AppLocalizations.of(context).translate(
                        'Gửi lại OTP ${state.otpResendTime > 0 ? '(${state.otpResendTime}s)' : ''}',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
