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
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_field/phone_input_widget.dart';

class ActiveLicenseInputPhone extends StatelessWidget {
  const ActiveLicenseInputPhone({super.key});

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
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen: (previous, current) {
              return (current.checkPhoneError != null &&
                  current.checkPhoneError != previous.checkPhoneError);
            },
            listener: _errorListener,
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
                            ).translate('Nhập số điện thoại'),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),

                          const SizedBox(height: Spacing.lg),

                          PhoneInputField(
                            initialCountryCode: 'VN',
                            onCountryInit:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .countryCodeChanged,
                            onChanged:
                                context.read<ActiveLicenseCubit>().phoneChanged,
                            onCountryChange:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .countryCodeChanged,
                            errorText: AppLocalizations.of(
                              context,
                            ).translate(state.phone.displayError),
                          ),

                          const SizedBox(height: Spacing.lg),

                          const Spacer(),

                          AppButton.primary(
                            text: AppLocalizations.of(
                              context,
                            ).translate('Tiếp tục'),
                            onPressed:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .checkPhoneNumber,
                            disabled: state.phone.isNotValid,
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
      context.go(AppRoutePaths.activeLicensePhoneInfo);
    }
  }

  void _errorListener(BuildContext context, ActiveLicenseState state) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(context).translate('Lỗi'),
      messageText: AppLocalizations.of(
        context,
      ).translate(state.checkPhoneError ?? ''),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(context).translate('Đóng'),
      isCloseable: false,
      onPrimaryAction: () {
        context.pop();
        context.read<ActiveLicenseCubit>().clearPhoneError();
      },
    );
  }
}
