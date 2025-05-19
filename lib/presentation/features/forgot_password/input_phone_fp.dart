import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/forgot_password/forgot_password_header.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/text_field/phone_input_widget.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';

final logger = Logger('InputPhoneFp');

class InputPhoneFp extends StatefulWidget {
  const InputPhoneFp({super.key, this.isFromChangePassword = false});

  final bool? isFromChangePassword;

  @override
  State<InputPhoneFp> createState() => _InputPhoneFpState();
}

class _InputPhoneFpState extends State<InputPhoneFp> {
  ForgotPasswordCubit? _forgotPasswordCubit;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late String? countryCode = 'VN';
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
    phoneController = TextEditingController();
    emailController = TextEditingController();
    if (widget.isFromChangePassword == true) {
      phoneController.text =
          context.read<UserCubit>().state.user?.phoneInfo?.phone ?? '';
      emailController.text = context.read<UserCubit>().state.user?.email ?? '';
      _forgotPasswordCubit?.phoneChanged(
        context.read<UserCubit>().state.user?.phoneInfo?.phone ?? '',
      );
      _forgotPasswordCubit?.emailChanged(emailController.text);
      setState(() {
        countryCode = context.read<UserCubit>().state.user?.country ?? 'VN';
      });
    }
  }

  @override
  void dispose() {
    _forgotPasswordCubit?.phoneChanged('');
    _forgotPasswordCubit?.emailReset();

    super.dispose();
  }

  void _showNotRegisteredDialog(
    BuildContext context,
    ForgotPasswordState state,
  ) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.forgot_password.notice'),
      messageText: AppLocalizations.of(context).translate(
        'app.forgot_password.phone_not_registered',
        params: {
          'method': AppLocalizations.of(context).translate(
            state.method == ForgotPasswordType.phone
                ? 'app.forgot_password.input_phone'
                : 'app.forgot_password.input_email',
          ),
        },
      ),
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
                _showNotRegisteredDialog(context, state);
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
                                controller: phoneController,
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
                                        .countryCodeInit,
                                initialCountryCode: countryCode ?? 'VN',
                                errorText: AppLocalizations.of(
                                  context,
                                ).translate(state.phone.displayError),
                                canEdit: widget.isFromChangePassword != true,
                              )
                              : TextFieldWidget(
                                controller: emailController,
                                onChanged:
                                    context
                                        .read<ForgotPasswordCubit>()
                                        .emailChanged,
                                errorText: AppLocalizations.of(
                                  context,
                                ).translate(state.email.displayError),
                                hintText: 'abc@gmail.com',
                                obscureText: false,
                                canEdit: widget.isFromChangePassword != true,
                                keyboardType: TextInputType.emailAddress,
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
