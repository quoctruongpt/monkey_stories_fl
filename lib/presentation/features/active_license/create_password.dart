import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_field/password_input_widget.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';

class ActiveLicenseCreatePassword extends StatelessWidget {
  const ActiveLicenseCreatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen: (previous, current) {
              return (current.isNewPhoneValid != null &&
                  current.isNewPhoneValid != previous.isNewPhoneValid);
            },
            listener: _checkPhoneListener,
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
                            ).translate('Tạo mật khẩu'),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),

                          const SizedBox(height: Spacing.sm),

                          Text(
                            '${state.phone.value.countryCode} ${state.phone.value.phoneNumber}',
                          ),

                          const SizedBox(height: Spacing.lg),

                          TextFieldWidget(
                            onChanged:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .passwordChanged,
                            labelText: AppLocalizations.of(
                              context,
                            ).translate('Tạo mật khẩu'),
                            errorText: AppLocalizations.of(
                              context,
                            ).translate(state.password.displayError),
                          ),
                          const SizedBox(height: Spacing.md),
                          TextFieldWidget(
                            onChanged:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .rePasswordChanged,
                            labelText: AppLocalizations.of(
                              context,
                            ).translate('Nhập lại mật khẩu'),
                            errorText: AppLocalizations.of(
                              context,
                            ).translate(state.rePassword.displayError),
                          ),

                          const Spacer(),

                          AppButton.primary(
                            text: AppLocalizations.of(
                              context,
                            ).translate('Hoàn thành'),
                            onPressed:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .createPasswordPressed,
                            disabled:
                                state.password.isNotValid ||
                                state.rePassword.isNotValid,
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

  void _checkPhoneListener(BuildContext context, ActiveLicenseState state) {
    if (state.isNewPhoneValid == true) {
      context.push(AppRoutePaths.activeLicenseCreatePassword);
    } else if (state.phoneInfo != null) {
      context.push(AppRoutePaths.activeLicensePhoneInfo);
    }
  }
}
