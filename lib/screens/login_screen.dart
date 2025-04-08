import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logging/logging.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart';
import 'package:monkey_stories/blocs/login/login_cubit.dart';
import 'package:monkey_stories/blocs/login/login_state.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/utils/lottie_utils.dart';
import 'package:monkey_stories/utils/validators.dart';
import 'package:monkey_stories/widgets/button_widget.dart';
import 'package:monkey_stories/widgets/horizontal_line_text.dart';
import 'package:monkey_stories/widgets/loading_overlay.dart';
import 'package:monkey_stories/widgets/social_login_button.dart';
import 'package:monkey_stories/widgets/text_and_action.dart';

final logger = Logger('LoginScreen');

class LoginScreenProvider extends StatelessWidget {
  const LoginScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthenticationCubit>()),
      child: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
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

                              TextField(
                                onChanged: (value) {
                                  context.read<LoginCubit>().usernameChanged(
                                    value,
                                  );
                                },
                                decoration: InputDecoration(
                                  labelText: 'Số điện thoại/Tên đăng nhập',
                                  errorText: state.username.displayError?.name,
                                  suffixIcon:
                                      state.username.isNotValid &&
                                              state.username.value.isNotEmpty
                                          ? IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.cancel,
                                              color:
                                                  AppTheme.textSecondaryColor,
                                            ),
                                          )
                                          : null,
                                ),
                              ),

                              const SizedBox(height: Spacing.md),

                              TextField(
                                onChanged: (value) {
                                  context.read<LoginCubit>().passwordChanged(
                                    value,
                                  );
                                },
                                obscureText: !state.isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu',
                                  errorText: state.password.displayError?.name,
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
                                  Text(
                                    'Device ID: 100600',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textGrayLightColor,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      /* TODO: Navigate to Forgot Password */
                                    },
                                    child: Text(
                                      "Quên mật khẩu?",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: Spacing.md),

                              AppButton.primary(
                                text: "Đăng nhập",
                                onPressed: () {
                                  context.read<LoginCubit>().loginSubmitted();
                                },
                                isFullWidth: true,
                                disabled: !state.isValidForm,
                              ),

                              const SizedBox(height: 20),

                              Center(
                                child: TextAndAction(
                                  text: 'Nếu bạn có mã kích hoạt, ',
                                  actionText: 'Nhập tại đây.',
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
                    bottom: Spacing.md + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Spacing.md),
                        child: HorizontalLineText(text: "Hoặc đăng nhập với"),
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
                                /* TODO: Handle Facebook Login */
                              },
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: SocialLoginButton(
                              backgroundColor: Colors.white,
                              googleIconAsset: 'assets/icons/svg/google.svg',
                              onPressed: () {
                                /* TODO: Handle Google Login */
                              },
                              isGoogle: true,
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: SocialLoginButton(
                              backgroundColor: Colors.black,
                              iconData: Icons.apple,
                              onPressed: () {
                                /* TODO: Handle Apple Login */
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: Spacing.lg),

                      Center(
                        child: TextAndAction(
                          text: 'Bạn chưa có tài khoản? ',
                          actionText: 'Đăng ký',
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
    );
  }
}
