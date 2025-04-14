import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logging/logging.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/bloc/auth/login/login_cubit.dart';
import 'package:monkey_stories/presentation/bloc/auth/login/login_state.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/lottie_utils.dart';
import 'package:monkey_stories/presentation/widgets/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/auth/footer_authentication.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_and_action.dart';
import 'package:monkey_stories/presentation/widgets/notice_dialog.dart';

final logger = Logger('LoginScreen');

class LoginScreenProvider extends StatelessWidget {
  const LoginScreenProvider({super.key, this.initialUsername});

  final String? initialUsername;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: LoginScreen(initialUsername: initialUsername),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.initialUsername});

  final String? initialUsername;

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

    // Call loadLastLogin after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Check if the state is still mounted
        context.read<LoginCubit>().loadLastLogin(widget.initialUsername);
      }
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
    context.go(AppRoutePaths.home);
  }

  void _handleLoginFailure(String errorMessage) {
    void clearErrorDialog() {
      context.read<LoginCubit>().clearErrorDialog();
      context.pop();
    }

    showCustomNoticeDialog(
      context: context,
      titleText: translate('login.popup_error.title'),
      messageText: errorMessage,
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionText: translate('login.popup_error.act'),
      onPrimaryAction: clearErrorDialog,
      onClose: clearErrorDialog,
    );
  }

  void _handleMaxFailedAttempts() {
    showCustomNoticeDialog(
      context: context,
      titleText: translate('login.popup_error.title'),
      messageText: translate('login.popup_error_pw.desc'),
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionText: translate('login.popup_error_pw.act'),
      onPrimaryAction: () {
        context.read<LoginCubit>().resetFailedAttempts();
      },
      secondaryActionText: translate('login.popup_error_pw.retry'),
      onSecondaryAction: () {
        context.read<LoginCubit>().resetFailedAttempts();
        FocusScope.of(context).requestFocus(_passwordFocusNode);
        context.pop();
      },
      onClose: () {
        context.read<LoginCubit>().resetFailedAttempts();
      },
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

  void _signUpPressed() {
    context.push(AppRoutePaths.signUp);
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
                                    _usernameController
                                        .selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _usernameController.text.length,
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
                                              state.username.displayError ?? '',
                                            )
                                            : null,
                                    suffixIcon:
                                        state.username.isNotValid &&
                                                state.username.value.isNotEmpty
                                            ? IconButton(
                                              onPressed: () {
                                                _usernameController.clear();
                                              },
                                              icon: const Icon(
                                                Icons.cancel,
                                                color:
                                                    AppTheme.textSecondaryColor,
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

                              const SizedBox(height: Spacing.md),

                              state.lastLogin?.name != null
                                  ? AppButton.secondary(
                                    text: state.lastLogin?.name ?? '',
                                    onPressed:
                                        context
                                            .read<LoginCubit>()
                                            .loginWithLastLogin,
                                    isFullWidth: true,
                                  )
                                  : const SizedBox.shrink(),

                              const SizedBox(height: Spacing.md),

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
                  bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(
                      left: Spacing.lg,
                      right: Spacing.lg,
                      bottom:
                          Spacing.md + MediaQuery.of(context).padding.bottom,
                    ),
                    child: FooterAuthentication(
                      textOnLine: translate('login.other_method'),
                      actionDescText: translate('login.sign_up.desc'),
                      actionText: translate('login.sign_up.act'),
                      onFacebookPress: () {
                        context.read<LoginCubit>().loginWithFacebook();
                      },
                      onGooglePress: () {
                        context.read<LoginCubit>().loginWithGoogle();
                      },
                      onApplePress: () {
                        context.read<LoginCubit>().loginWithApple();
                      },
                      onActionPress: _signUpPressed,
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
