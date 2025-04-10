import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logging/logging.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/blocs/app/app_cubit.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart';
import 'package:monkey_stories/blocs/login/login_cubit.dart';
import 'package:monkey_stories/blocs/login/login_state.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/navigation/app_routes.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/utils/lottie_utils.dart';
import 'package:monkey_stories/widgets/button_widget.dart';
import 'package:monkey_stories/widgets/horizontal_line_text.dart';
import 'package:monkey_stories/widgets/loading_overlay.dart';
import 'package:monkey_stories/widgets/social_login_button.dart';
import 'package:monkey_stories/widgets/text_and_action.dart';
import 'package:monkey_stories/repositories/auth_repository.dart';
import 'package:monkey_stories/widgets/notice_dialog.dart';

final logger = Logger('LoginScreen');

class LoginScreenProvider extends StatelessWidget {
  const LoginScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => LoginCubit(
            context.read<AuthenticationCubit>(),
            context.read<AuthRepository>(),
          ),
      child: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  final FocusNode _passwordFocusNode = FocusNode();
  late String Function(String key) translate =
      AppLocalizations.of(context).translate;

  @override
  void initState() {
    super.initState();
    final initialValue = context.read<LoginCubit>().state.username.value;
    _usernameController = TextEditingController(text: initialValue);
    _usernameController.addListener(() {
      context.read<LoginCubit>().usernameChanged(_usernameController.text);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _loginPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<LoginCubit>().loginSubmitted();
  }

  void _handleLoginSuccess() {
    context.go(AppRoutes.home);
  }

  void _handleLoginFailure(String errorMessage) {
    void clearErrorDialog() {
      context.read<LoginCubit>().clearErrorDialog();
      context.pop();
    }

    showCustomNoticeDialog(
      context: context,
      titleKey: 'login.popup_error.title',
      messageKey: errorMessage,
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionTextKey: 'login.popup_error.act',
      onPrimaryAction: clearErrorDialog,
      onClose: clearErrorDialog,
      translate: translate,
    );
  }

  void _handleMaxFailedAttempts() {
    showCustomNoticeDialog(
      context: context,
      titleKey: 'login.popup_error.title',
      messageKey: 'login.popup_error_pw.desc',
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionTextKey: 'login.popup_error_pw.act',
      onPrimaryAction: () {
        context.read<LoginCubit>().resetFailedAttempts();
      },
      secondaryActionTextKey: 'login.popup_error_pw.retry',
      onSecondaryAction: () {
        context.read<LoginCubit>().resetFailedAttempts();
        FocusScope.of(context).requestFocus(_passwordFocusNode);
        context.pop();
      },
      onClose: () {
        context.read<LoginCubit>().resetFailedAttempts();
      },
      translate: translate,
    );
  }

  void _listenLoginState(LoginState state) {
    if (state.status == FormSubmissionStatus.success) {
      _handleLoginSuccess();
      return;
    }
    if (state.status == FormSubmissionStatus.failure &&
        state.errorMessageDialog != null) {
      _handleLoginFailure(state.errorMessageDialog!);
      return;
    }
    if (state.failedAttempts >= 5) {
      _handleMaxFailedAttempts();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          _listenLoginState(state);
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final isLoading = state.status == FormSubmissionStatus.loading;

            return Stack(
              children: [
                Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    leading:
                        context.canPop()
                            ? IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                if (context.canPop()) context.pop();
                              },
                            )
                            : null,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Colors.black),
                  ),
                  body: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.lg,
                        right: Spacing.lg,
                        top: Spacing.xxl,
                      ),
                      child: Form(
                        child: Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/monkey_hello.lottie',
                                  decoder: customDecoder,
                                  width: 151,
                                  height: 169,
                                ),

                                const SizedBox(height: Spacing.sm),

                                BlocListener<LoginCubit, LoginState>(
                                  listener: (context, state) {
                                    if (_usernameController.text !=
                                        state.username.value) {
                                      _usernameController.text =
                                          state.username.value;
                                      // Có thể cần di chuyển con trỏ về cuối
                                      _usernameController.selection =
                                          TextSelection.fromPosition(
                                            TextPosition(
                                              offset:
                                                  _usernameController
                                                      .text
                                                      .length,
                                            ),
                                          );
                                    }
                                  },
                                  child: TextField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(
                                        context,
                                      ).translate('login.username'),
                                      errorText:
                                          state.username.displayError != null
                                              ? AppLocalizations.of(
                                                context,
                                              ).translate(
                                                state.username.displayError ??
                                                    '',
                                              )
                                              : null,
                                      suffixIcon:
                                          state.username.isNotValid &&
                                                  state
                                                      .username
                                                      .value
                                                      .isNotEmpty
                                              ? IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<LoginCubit>()
                                                      .usernameChanged('');
                                                },
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color:
                                                      AppTheme
                                                          .textSecondaryColor,
                                                ),
                                              )
                                              : null,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: Spacing.md),

                                TextField(
                                  focusNode: _passwordFocusNode,
                                  onChanged: (value) {
                                    context.read<LoginCubit>().passwordChanged(
                                      value,
                                    );
                                  },
                                  obscureText: !state.isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: translate('login.password'),
                                    errorText:
                                        state.password.displayError != null
                                            ? AppLocalizations.of(
                                              context,
                                            ).translate(
                                              state.password.displayError!,
                                            )
                                            : null,
                                    suffixIcon: IconButton(
                                      onPressed:
                                          context
                                              .read<LoginCubit>()
                                              .togglePasswordVisibility,
                                      icon: Icon(
                                        state.isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: Spacing.sm),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BlocBuilder<AppCubit, AppState>(
                                      builder: (context, state) {
                                        return Text(
                                          '${translate('login.device_id')}: ${state.deviceId}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.copyWith(
                                            color: AppTheme.textGrayLightColor,
                                          ),
                                        );
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        /* TODO: Navigate to Forgot Password */
                                      },
                                      child: Text(
                                        translate('login.forgot_password'),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                if (state.errorMessage != null &&
                                    state.errorMessage!.isNotEmpty)
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate(state.errorMessage!),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: AppTheme.errorColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                const SizedBox(height: Spacing.md),
                                AppButton.primary(
                                  text: translate('login.act.title'),
                                  onPressed: _loginPressed,
                                  isFullWidth: true,
                                  disabled: !state.isValidForm,
                                ),

                                const SizedBox(height: 20),

                                Center(
                                  child: TextAndAction(
                                    text: translate('login.active_code.desc'),
                                    actionText: translate(
                                      'login.active_code.act',
                                    ),
                                    onActionTap: () {
                                      /* TODO: Handle activation code */
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(
                      left: Spacing.lg,
                      right: Spacing.lg,
                      bottom:
                          Spacing.md + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                          ),
                          child: HorizontalLineText(
                            text: translate('login.other_method'),
                          ),
                        ),

                        const SizedBox(height: Spacing.xl),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SocialLoginButton(
                                backgroundColor: Colors.blue.shade700,
                                iconData: Icons.facebook,
                                onPressed: () {
                                  context
                                      .read<LoginCubit>()
                                      .loginWithFacebook();
                                },
                              ),
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: SocialLoginButton(
                                backgroundColor: Colors.white,
                                googleIconAsset: 'assets/icons/svg/google.svg',
                                onPressed: () {
                                  context.read<LoginCubit>().loginWithGoogle();
                                },
                                isGoogle: true,
                              ),
                            ),
                            const SizedBox(width: Spacing.md),
                            Platform.isIOS
                                ? Expanded(
                                  child: SocialLoginButton(
                                    backgroundColor: Colors.black,
                                    iconData: Icons.apple,
                                    onPressed: () {
                                      context
                                          .read<LoginCubit>()
                                          .loginWithApple();
                                    },
                                  ),
                                )
                                : const SizedBox.shrink(),
                          ],
                        ),

                        const SizedBox(height: Spacing.lg),

                        Center(
                          child: TextAndAction(
                            text: translate('login.sign_up.desc'),
                            actionText: translate('login.sign_up.act'),
                            onActionTap: () {
                              /* TODO: Navigate to Register Screen */
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                if (isLoading) const LoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }
}
