import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/change_password/change_password_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_field/password_input_widget.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChangePasswordCubit>(),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listenWhen:
          (previous, current) =>
              previous.isSuccess != current.isSuccess ||
              previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          context.pushReplacement(AppRoutePaths.changePasswordSuccess);
        } else if (state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      builder: (context, state) {
        return KeyboardDismisser(
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBarWidget(
                  title: AppLocalizations.of(
                    context,
                  ).translate('app.change_password.title'),
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              PasswordInputField(
                                onChanged:
                                    (value) => context
                                        .read<ChangePasswordCubit>()
                                        .onCurrentPasswordChanged(value),
                                hintText: AppLocalizations.of(
                                  context,
                                ).translate(
                                  'app.change_password.current_password',
                                ),
                                labelTopText: AppLocalizations.of(
                                  context,
                                ).translate(
                                  'app.change_password.current_password',
                                ),
                                labelTopIcon: SvgPicture.asset(
                                  'assets/icons/svg/password.svg',
                                  color: AppTheme.textSecondaryColor,
                                ),
                                errorText: AppLocalizations.of(
                                  context,
                                ).translate(state.currentPassword.displayError),
                                obscureText: state.isCurrentPasswordObscured,
                                onObscureTextToggle: () {
                                  context
                                      .read<ChangePasswordCubit>()
                                      .toggleCurrentPasswordVisibility();
                                },
                              ),
                              const SizedBox(height: Spacing.md),
                              PasswordInputField(
                                onChanged:
                                    (value) => context
                                        .read<ChangePasswordCubit>()
                                        .onNewPasswordChanged(value),
                                hintText: AppLocalizations.of(
                                  context,
                                ).translate('app.change_password.new_password'),
                                labelTopText: AppLocalizations.of(
                                  context,
                                ).translate('app.change_password.new_password'),
                                labelTopIcon: SvgPicture.asset(
                                  'assets/icons/svg/password.svg',
                                  color: AppTheme.textSecondaryColor,
                                ),
                                errorText: AppLocalizations.of(
                                  context,
                                ).translate(state.newPassword.displayError),
                                obscureText: state.isNewPasswordObscured,
                                onObscureTextToggle: () {
                                  context
                                      .read<ChangePasswordCubit>()
                                      .toggleNewPasswordVisibility();
                                },
                              ),
                              const SizedBox(height: Spacing.md),
                              PasswordInputField(
                                onChanged:
                                    (value) => context
                                        .read<ChangePasswordCubit>()
                                        .onConfirmPasswordChanged(value),
                                hintText: AppLocalizations.of(
                                  context,
                                ).translate(
                                  'app.change_password.confirm_password',
                                ),
                                labelTopText: AppLocalizations.of(
                                  context,
                                ).translate(
                                  'app.change_password.confirm_password',
                                ),
                                labelTopIcon: SvgPicture.asset(
                                  'assets/icons/svg/password.svg',
                                  color: AppTheme.textSecondaryColor,
                                ),
                                errorText: AppLocalizations.of(
                                  context,
                                ).translate(state.confirmPassword.displayError),
                                obscureText: state.isConfirmPasswordObscured,
                                onObscureTextToggle: () {
                                  context
                                      .read<ChangePasswordCubit>()
                                      .toggleConfirmPasswordVisibility();
                                },
                              ),
                              const SizedBox(height: Spacing.md),
                            ],
                          ),
                        ),
                      ),

                      AppButton.primary(
                        text: AppLocalizations.of(
                          context,
                        ).translate('app.change_password.save'),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          context
                              .read<ChangePasswordCubit>()
                              .submitChangePassword();
                        },
                        disabled: !state.status,
                      ),
                      const SizedBox(height: Spacing.sm),
                      TextButton(
                        onPressed: () {
                          context.pushNamed(
                            AppRouteNames.chooseMethodFp,
                            queryParameters: {'isFromChangePassword': 'true'},
                          );
                        },
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).translate('app.change_password.forgot_password'),
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              state.isLoading
                  ? const LoadingOverlay()
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
