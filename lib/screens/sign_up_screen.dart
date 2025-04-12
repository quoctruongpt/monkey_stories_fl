import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logging/logging.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart';
import 'package:monkey_stories/blocs/sign_up/sign_up_cubit.dart';
import 'package:monkey_stories/core/constants/auth.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/navigation/app_routes.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/repositories/auth_repository.dart';
import 'package:monkey_stories/utils/lottie_utils.dart';
import 'package:monkey_stories/widgets/button_widget.dart';
import 'package:monkey_stories/widgets/footer_authentication.dart';
import 'package:monkey_stories/widgets/loading_overlay.dart';
import 'package:monkey_stories/widgets/notice_dialog.dart';
import 'package:monkey_stories/widgets/phone_input_widget.dart';
import 'package:monkey_stories/widgets/text_field_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SignUpCubit(
            context.read<AuthRepository>(),
            context.read<AuthenticationCubit>(),
          ),
      child: const SignUp(),
    );
  }
}

final logger = Logger('SignUpScreen');

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late PageController _pageController;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    final initialValue =
        context.read<SignUpCubit>().state.phone.value.phoneNumber;
    _phoneController = TextEditingController(text: initialValue);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _pageController = PageController();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleBackPressed() {
    if (context.read<SignUpCubit>().state.step == StepSignUp.password) {
      context.read<SignUpCubit>().backToPhone();
      return;
    }

    context.pop();
  }

  void _handleContinue() {
    if (context.read<SignUpCubit>().state.step == StepSignUp.phone) {
      context.read<SignUpCubit>().nextToPassword();
      return;
    }

    context.read<SignUpCubit>().signUpPressed();
  }

  void _onStepChanged(StepSignUp step) {
    FocusScope.of(context).unfocus();
    if (step == StepSignUp.phone) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (step == StepSignUp.password) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        _passwordFocusNode.requestFocus();
      });
    }
  }

  void _handlePhoneError(int? errorCode) {
    if (errorCode == AuthConstants.phoneExistCode) {
      showCustomNoticeDialog(
        context: context,
        titleKey: 'Thông báo',
        messageKey:
            'Số điện thoại này đã được đăng ký với Monkey, ba mẹ hãy đăng nhập nhé.',
        imageAsset: 'assets/images/monkey_confused.png',
        primaryActionTextKey: 'Đăng nhập',
        translate: AppLocalizations.of(context).translate,
        onPrimaryAction: () {
          final encodedPhone = Uri.encodeComponent(
            '${context.read<SignUpCubit>().state.phone.value.countryCode}${_phoneController.text}',
          );
          context.push('${AppRoutes.login}?username=$encodedPhone');
        },
        onSecondaryAction: () {
          context.pop();
        },
        secondaryActionTextKey: 'Hủy',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;

    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) => current.isSignUpSuccess == true,
      listener: (context, state) {
        context.goNamed(AppRouteNames.home);
      },

      child: KeyboardDismisser(
        child: Stack(
          children: [
            Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: _handleBackPressed,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.textColor,
                  ),
                ),

                backgroundColor: Colors.transparent,
              ),

              body: Padding(
                padding: const EdgeInsets.only(
                  left: Spacing.lg,
                  right: Spacing.lg,
                  top: Spacing.xxl,
                  bottom: Spacing.lg,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Lottie.asset(
                                'assets/lottie/monkey_hello.lottie',
                                decoder: customDecoder,
                                width: 151,
                                height: 169,
                              ),

                              SizedBox(
                                height: 250,
                                child: BlocListener<SignUpCubit, SignUpState>(
                                  listenWhen:
                                      (previous, current) =>
                                          previous.step != current.step,
                                  listener: (context, state) {
                                    _onStepChanged(state.step);
                                  },
                                  child: BlocListener<SignUpCubit, SignUpState>(
                                    listenWhen:
                                        (previous, current) =>
                                            previous.phoneErrorMessage !=
                                            current.phoneErrorMessage,
                                    listener: (context, state) {
                                      _handlePhoneError(state.phoneErrorCode);
                                    },
                                    child: BlocBuilder<
                                      SignUpCubit,
                                      SignUpState
                                    >(
                                      builder: (context, state) {
                                        return PageView(
                                          controller: _pageController,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            PhoneInput(
                                              controller: _phoneController,
                                              onCountryChange: (countryCode) {
                                                context
                                                    .read<SignUpCubit>()
                                                    .countryCodeChanged(
                                                      countryCode,
                                                    );
                                              },
                                              onPhoneChanged: (phoneNumber) {
                                                context
                                                    .read<SignUpCubit>()
                                                    .phoneChanged(phoneNumber);
                                              },
                                              isLoading:
                                                  state.isCheckingPhone ??
                                                  false,
                                              errorText:
                                                  (state.phone.displayError !=
                                                          null
                                                      ? translate(
                                                        state
                                                            .phone
                                                            .displayError,
                                                      )
                                                      : null) ??
                                                  state.phoneErrorMessage,
                                              isPhoneValid:
                                                  state.isPhoneValid &&
                                                  state.phone.isValid,
                                              initialCountryCode: 'VN',
                                              onCountryInit: (countryCode) {
                                                context
                                                    .read<SignUpCubit>()
                                                    .countryCodeChanged(
                                                      countryCode,
                                                    );
                                              },
                                            ),

                                            PasswordInput(
                                              controllerPassword:
                                                  _passwordController,
                                              controllerConfirmPassword:
                                                  _confirmPasswordController,
                                              onChangedPassword:
                                                  context
                                                      .read<SignUpCubit>()
                                                      .passwordChanged,
                                              onChangedConfirmPassword:
                                                  context
                                                      .read<SignUpCubit>()
                                                      .confirmPasswordChanged,
                                              isShowPassword:
                                                  state.isShowPassword,
                                              toggleShowPassword:
                                                  context
                                                      .read<SignUpCubit>()
                                                      .toggleShowPassword,
                                              passwordErrorText:
                                                  state.password.displayError !=
                                                          null
                                                      ? translate(
                                                        state
                                                            .password
                                                            .displayError,
                                                      )
                                                      : null,
                                              confirmPasswordErrorText:
                                                  state.confirmPassword.isPure
                                                      ? null
                                                      : state
                                                              .confirmPassword
                                                              .displayError !=
                                                          null
                                                      ? translate(
                                                        state
                                                            .confirmPassword
                                                            .displayError,
                                                      )
                                                      : !state
                                                          .isConfirmPasswordCorrect
                                                      ? 'Mật khẩu không trùng khớp'
                                                      : null,
                                              isPasswordValid:
                                                  state.password.isValid,
                                              isConfirmPasswordValid:
                                                  state
                                                      .confirmPassword
                                                      .isValid &&
                                                  state
                                                      .isConfirmPasswordCorrect,
                                              focusNode: _passwordFocusNode,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              BlocBuilder<SignUpCubit, SignUpState>(
                                builder: (context, state) {
                                  return Text(
                                    translate(state.signUpErrorMessage),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium?.copyWith(
                                      color: AppTheme.errorColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<SignUpCubit, SignUpState>(
                      builder: (context, state) {
                        final bool enableContinueButton =
                            state.step == StepSignUp.phone
                                ? state.phone.isValid && state.isPhoneValid
                                : state.password.isValid &&
                                    state.confirmPassword.isValid &&
                                    state.isConfirmPasswordCorrect;

                        return AppButton.primary(
                          text: translate('Tiếp tục'),
                          onPressed: _handleContinue,
                          isFullWidth: true,
                          disabled: !enableContinueButton,
                        );
                      },
                    ),
                  ],
                ),
              ),

              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  left: Spacing.lg,
                  right: Spacing.lg,
                  bottom: Spacing.md + MediaQuery.of(context).padding.bottom,
                ),
                child: FooterAuthentication(
                  textOnLine: translate('Hoặc đăng nhập với'),
                  onActionPress: () {},
                  onApplePress: () {},
                  onFacebookPress: () {
                    _passwordFocusNode.requestFocus();
                  },
                  onGooglePress: () {},
                  actionDescText: translate('Tôi đã có tài khoản. '),
                  actionText: translate('Đăng nhập'),
                ),
              ),
            ),

            BlocBuilder<SignUpCubit, SignUpState>(
              builder: (context, state) {
                return state.isSignUpLoading
                    ? const LoadingOverlay()
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    super.key,
    required this.controller,
    required this.onCountryChange,
    required this.onPhoneChanged,
    this.isLoading = false,
    this.errorText,
    this.isPhoneValid = false,
    this.initialCountryCode = 'VN',
    this.onCountryInit,
  });

  final TextEditingController controller;
  final void Function(String) onCountryChange;
  final void Function(String) onPhoneChanged;
  final bool isLoading;
  final String? errorText;
  final bool isPhoneValid;
  final String initialCountryCode;
  final void Function(String)? onCountryInit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Nhập số điện thoại', style: TextStyle(fontSize: 20)),

        const SizedBox(height: Spacing.md),

        PhoneInputField(
          controller: controller,
          onCountryChange: onCountryChange,
          onChanged: onPhoneChanged,
          isLoading: isLoading,
          errorText: errorText,
          isPhoneValid: isPhoneValid,
          initialCountryCode: initialCountryCode,
          onCountryInit: onCountryInit,
        ),
      ],
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.controllerPassword,
    required this.controllerConfirmPassword,
    required this.onChangedPassword,
    required this.onChangedConfirmPassword,
    required this.isShowPassword,
    required this.toggleShowPassword,
    required this.focusNode,
    this.passwordErrorText,
    this.confirmPasswordErrorText,
    this.isPasswordValid = false,
    this.isConfirmPasswordValid = false,
  });

  final TextEditingController controllerPassword;
  final TextEditingController controllerConfirmPassword;
  final bool isShowPassword;
  final void Function(String) onChangedPassword;
  final void Function(String) onChangedConfirmPassword;
  final VoidCallback toggleShowPassword;
  final String? passwordErrorText;
  final String? confirmPasswordErrorText;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Tạo mật khẩu', style: TextStyle(fontSize: 20)),
        const SizedBox(height: Spacing.md),
        PasswordInputField(
          controller: controllerPassword,
          onChanged: onChangedPassword,
          hintText: 'Mật khẩu',
          obscureText: !isShowPassword,
          onObscureTextToggle: toggleShowPassword,
          errorText: passwordErrorText,
          isPasswordValid: isPasswordValid,
          passwordValidText: 'Mật khẩu khả dụng',
          focusNode: focusNode,
        ),
        const SizedBox(height: Spacing.md),
        PasswordInputField(
          controller: controllerConfirmPassword,
          onChanged: onChangedConfirmPassword,
          hintText: 'Nhập lại mật khẩu',
          obscureText: !isShowPassword,
          onObscureTextToggle: toggleShowPassword,
          errorText: confirmPasswordErrorText,
          isPasswordValid: isConfirmPasswordValid,
          passwordValidText: 'Mật khẩu trùng khớp',
        ),
      ],
    );
  }
}
