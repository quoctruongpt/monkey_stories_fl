import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/forgot_password/forgot_password_header.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/text_field/phone_input_widget.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';

final logger = Logger('InputPhoneFp');

class InputPhoneFp extends StatefulWidget {
  const InputPhoneFp({super.key});

  @override
  State<InputPhoneFp> createState() => _InputPhoneFpState();
}

class _InputPhoneFpState extends State<InputPhoneFp> {
  ForgotPasswordCubit? _forgotPasswordCubit;
  Future<void> _onPressed(BuildContext context) async {
    final isSendDone = await context.read<ForgotPasswordCubit>().sendOtp();
    if (isSendDone) {
      context.pushNamed(AppRouteNames.inputOtpFp);
    }
  }

  @override
  void initState() {
    super.initState();
    _forgotPasswordCubit = context.read<ForgotPasswordCubit>();
  }

  @override
  void dispose() {
    _forgotPasswordCubit?.phoneChanged('');
    _forgotPasswordCubit?.emailChanged('');

    super.dispose();
  }

  void _showNotRegisteredDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.forgot_password.notice'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.forgot_password.phone_not_registered'),
      imageAsset: 'assets/images/monkey_notice.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.forgot_password.try_again'),
      onPrimaryAction: () {
        context.read<ForgotPasswordCubit>().hideNotRegisteredDialog();
        context.pop();
      },
      onClose: () {
        context.read<ForgotPasswordCubit>().hideNotRegisteredDialog();
        context.pop();
      },
    );
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
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listenWhen:
                (previous, current) =>
                    previous.isShowNotRegisteredDialog !=
                    current.isShowNotRegisteredDialog,
            listener: (context, state) {
              if (state.isShowNotRegisteredDialog) {
                _showNotRegisteredDialog(context);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ForgotPasswordHeader(
                            description: AppLocalizations.of(context).translate(
                              'app.forgot_password.input',
                              params: {
                                'method': AppLocalizations.of(
                                  context,
                                ).translate(
                                  state.method == ForgotPasswordType.phone
                                      ? 'app.forgot_password.input_phone'
                                      : 'app.forgot_password.input_email',
                                ),
                              },
                            ),
                          ),

                          (state.method == ForgotPasswordType.phone)
                              ? PhoneInputField(
                                onChanged:
                                    context
                                        .read<ForgotPasswordCubit>()
                                        .phoneChanged,
                                onCountryChange:
                                    context
                                        .read<ForgotPasswordCubit>()
                                        .countryCodeChanged,
                                onCountryInit:
                                    context
                                        .read<ForgotPasswordCubit>()
                                        .countryCodeChanged,
                                initialCountryCode: 'VN',
                                errorText: AppLocalizations.of(
                                  context,
                                ).translate(state.phone.displayError),
                              )
                              : TextFieldWidget(
                                onChanged:
                                    context
                                        .read<ForgotPasswordCubit>()
                                        .emailChanged,
                                errorText: AppLocalizations.of(
                                  context,
                                ).translate(state.email.displayError),
                                hintText: 'abc@gmail.com',
                                obscureText: false,
                              ),

                          Text(
                            state.phoneErrorOther ?? '',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppTheme.errorColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppButton.primary(
                    text: AppLocalizations.of(
                      context,
                    ).translate('app.forgot_password.send_otp'),
                    onPressed: () => _onPressed(context),
                    disabled:
                        state.method == ForgotPasswordType.phone
                            ? !state.phone.isValid
                            : !state.email.isValid,
                    isLoading: state.isLoading,
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
