import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/lottie_utils.dart';
import 'package:monkey_stories/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:monkey_stories/presentation/widgets/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/text_field/password_input_widget.dart';

class InputNewPasswordFp extends StatelessWidget {
  const InputNewPasswordFp({super.key});

  Future<void> _onUpdatePassword(BuildContext context) async {
    final result = await context.read<ForgotPasswordCubit>().changePassword();
    if (result) {
      context.goNamed(AppRouteNames.forgotPasswordSuccess);
    }
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/lottie/monkey_write.lottie',
                            decoder: customDecoder,
                            width: 134,
                            height: 152,
                          ),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            AppLocalizations.of(
                              context,
                            ).translate('Cập nhật mật khẩu'),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: Spacing.xxl),

                          PasswordInputField(
                            onChanged:
                                context
                                    .read<ForgotPasswordCubit>()
                                    .passwordChanged,
                            labelText: AppLocalizations.of(
                              context,
                            ).translate('Mật khẩu'),
                            errorText: AppLocalizations.of(
                              context,
                            ).translate(state.password.displayError),
                            obscureText: !state.isShowPassword,
                            onObscureTextToggle:
                                context
                                    .read<ForgotPasswordCubit>()
                                    .toggleShowPassword,
                          ),
                          const SizedBox(height: Spacing.md),
                          PasswordInputField(
                            onChanged:
                                context
                                    .read<ForgotPasswordCubit>()
                                    .confirmPasswordChanged,
                            labelText: AppLocalizations.of(
                              context,
                            ).translate('Nhập lại mật khẩu'),
                            errorText: AppLocalizations.of(
                              context,
                            ).translate(state.confirmPassword.displayError),
                            obscureText: !state.isShowPassword,
                            onObscureTextToggle:
                                context
                                    .read<ForgotPasswordCubit>()
                                    .toggleShowPassword,
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppButton.primary(
                    text: AppLocalizations.of(context).translate('Cập nhật'),
                    onPressed: () => _onUpdatePassword(context),
                    disabled:
                        !state.password.isValid ||
                        !state.confirmPassword.isValid,
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
