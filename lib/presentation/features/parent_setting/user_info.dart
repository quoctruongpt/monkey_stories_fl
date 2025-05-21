import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/account/update_user_info/update_user_info_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_field/phone_input_widget.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UpdateUserInfoCubit>(),
      child: const UserInfoView(),
    );
  }
}

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    final nameInitial = context.read<UserCubit>().state.user?.name;
    final phoneInitial =
        context.read<UserCubit>().state.user?.phoneInfo?.phone ?? '';
    final emailInitial = context.read<UserCubit>().state.user?.email;
    nameController = TextEditingController(text: nameInitial);
    phoneController = TextEditingController(
      text:
          phoneInitial.startsWith('0')
              ? phoneInitial.replaceFirst('0', '')
              : phoneInitial,
    );
    emailController = TextEditingController(text: emailInitial);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _showCreateAccountDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.user_info.create_account'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.user_info.create_account_message'),
      imageAsset: 'assets/images/monkey_notice.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.user_info.create_account.act'),
      secondaryActionText: AppLocalizations.of(
        context,
      ).translate('app.user_info.create_account.act2'),
      onPrimaryAction: () {
        context.push(AppRoutePaths.signUp);
      },
      onSecondaryAction: () {
        context.pop();
      },
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.user_info.create_account.password'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.user_info.create_account.password_message'),
      child: BlocProvider.value(
        value: context.read<UpdateUserInfoCubit>(),
        child: BlocConsumer<UpdateUserInfoCubit, UpdateUserInfoState>(
          listenWhen:
              (previous, current) =>
                  previous.isPasswordAuthenticated !=
                  current.isPasswordAuthenticated,
          listener: (context, state) {
            if (state.isPasswordAuthenticated) {
              context.pop();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: Spacing.md),
                TextFieldWidget(
                  hintText: AppLocalizations.of(
                    context,
                  ).translate('app.user_info.create_account.password.label'),
                  onChanged: (value) {
                    context.read<UpdateUserInfoCubit>().passwordChanged(value);
                  },
                  errorText: AppLocalizations.of(context).translate(
                    state.password.displayError ?? state.passwordErrorMessage,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                AppButton.primary(
                  text: AppLocalizations.of(
                    context,
                  ).translate('app.user_info.create_account.password.confirm'),
                  onPressed: () {
                    context.read<UpdateUserInfoCubit>().confirmPassword();
                  },
                  disabled: state.password.isNotValid,
                  isLoading: state.isPasswordConfirming,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateUserInfoCubit, UpdateUserInfoState>(
      listenWhen:
          (previous, current) =>
              previous.isSuccess != current.isSuccess ||
              previous.errorMessage != current.errorMessage,
      listener: (context, updateState) {
        if (updateState.isSuccess) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.successColor,
              content: Text(
                AppLocalizations.of(
                  context,
                ).translate('app.user_info.update_success'),
              ),
            ),
          );
        }
        if (updateState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(
                  context,
                ).translate(updateState.errorMessage),
              ),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      builder: (context, updateState) {
        return Stack(
          children: [
            KeyboardDismisser(
              child: Scaffold(
                appBar: AppBarWidget(
                  title: AppLocalizations.of(
                    context,
                  ).translate('app.user_info.title'),
                ),
                body: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: Spacing.md,
                          right: Spacing.md,
                          bottom: Spacing.md,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFieldWidget(
                                      controller: nameController,
                                      onTap:
                                          state.user?.loginType ==
                                                  LoginType.skip
                                              ? () => _showCreateAccountDialog(
                                                context,
                                              )
                                              : null,
                                      onChanged: (value) {
                                        context
                                            .read<UpdateUserInfoCubit>()
                                            .nameChanged(value);
                                      },
                                      hintText: AppLocalizations.of(
                                        context,
                                      ).translate('app.user_info.name.hint'),
                                      labelTopText: AppLocalizations.of(
                                        context,
                                      ).translate('app.user_info.name.label'),
                                      labelTopIcon: SvgPicture.asset(
                                        'assets/icons/svg/person.svg',
                                      ),
                                      errorText:
                                          updateState.name.value !=
                                                  state.user?.name
                                              ? AppLocalizations.of(
                                                context,
                                              ).translate(
                                                updateState.name.displayError,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(height: Spacing.lg),
                                    PhoneInputField(
                                      controller: phoneController,
                                      initialCountryCode:
                                          state.user?.country ?? 'VN',
                                      onTap:
                                          state.user?.loginType ==
                                                  LoginType.skip
                                              ? () => _showCreateAccountDialog(
                                                context,
                                              )
                                              : !updateState
                                                  .isPasswordAuthenticated
                                              ? () =>
                                                  _showPasswordDialog(context)
                                              : null,
                                      labelTopText: AppLocalizations.of(
                                        context,
                                      ).translate('app.user_info.phone.label'),
                                      labelTopIcon: SvgPicture.asset(
                                        'assets/icons/svg/call.svg',
                                      ),
                                      onChanged: (value) {
                                        context
                                            .read<UpdateUserInfoCubit>()
                                            .phoneChanged(value);
                                      },
                                      onCountryChange: (value) {
                                        context
                                            .read<UpdateUserInfoCubit>()
                                            .countryCodeChanged(value);
                                      },
                                      onCountryInit: (value) {
                                        context
                                            .read<UpdateUserInfoCubit>()
                                            .countryCodeInit(value);
                                      },
                                      errorText:
                                          (updateState
                                                          .phone
                                                          .value
                                                          .phoneNumber !=
                                                      state
                                                          .user
                                                          ?.phoneInfo
                                                          ?.phone ||
                                                  updateState
                                                          .phone
                                                          .value
                                                          .countryCode !=
                                                      state
                                                          .user
                                                          ?.phoneInfo
                                                          ?.countryCode)
                                              ? AppLocalizations.of(
                                                context,
                                              ).translate(
                                                updateState.phone.displayError,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(height: Spacing.lg),
                                    TextFieldWidget(
                                      controller: emailController,
                                      onTap:
                                          state.user?.loginType ==
                                                  LoginType.skip
                                              ? () => _showCreateAccountDialog(
                                                context,
                                              )
                                              : !updateState
                                                  .isPasswordAuthenticated
                                              ? () =>
                                                  _showPasswordDialog(context)
                                              : null,
                                      onChanged: (value) {
                                        context
                                            .read<UpdateUserInfoCubit>()
                                            .emailChanged(value);
                                      },
                                      hintText: AppLocalizations.of(
                                        context,
                                      ).translate('app.user_info.email.hint'),
                                      labelTopText: AppLocalizations.of(
                                        context,
                                      ).translate('app.user_info.email.label'),
                                      labelTopIcon: SvgPicture.asset(
                                        'assets/icons/svg/message.svg',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      errorText:
                                          updateState.email.value !=
                                                  state.user?.email
                                              ? AppLocalizations.of(
                                                context,
                                              ).translate(
                                                updateState.email.displayError,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(height: Spacing.lg),
                                  ],
                                ),
                              ),
                            ),
                            AppButton.primary(
                              text: AppLocalizations.of(
                                context,
                              ).translate('app.user_info.save'),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                context
                                    .read<UpdateUserInfoCubit>()
                                    .updateUserInfo();
                              },
                              disabled: !updateState.isButtonEnabled,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            updateState.isLoading
                ? const LoadingOverlay()
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
