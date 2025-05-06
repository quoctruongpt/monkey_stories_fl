import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/active_license/popup_merge_lifetime_to_paid.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';

class ActiveLicenseLastLoginInfo extends StatelessWidget {
  const ActiveLicenseLastLoginInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActiveLicenseCubit, ActiveLicenseState>(
      listenWhen:
          (previous, current) =>
              current.showMergeLifetimeWarning ==
                  PositionShowWarning.lastLoginAccount &&
              current.showMergeLifetimeWarning !=
                  previous.showMergeLifetimeWarning,
      listener: _showMergeLifetimeWarningListener,
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBarWidget(
                title: AppLocalizations.of(
                  context,
                ).translate('Liên kết tài khoản'),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Spacing.md,
                    right: Spacing.md,
                    bottom: Spacing.lg,
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).translate(
                          'Ba mẹ có muốn kích hoạt gói học trên tài khoản này không?',
                        ),
                      ),

                      const SizedBox(height: Spacing.xxl),

                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: DashedBorder.fromBorderSide(
                            dashLength: 8,
                            side: BorderSide(
                              color: AppTheme.lightGrayColor,
                              width: 2,
                            ),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.lg,
                                horizontal: Spacing.md,
                              ),
                              child: Column(
                                children: [
                                  state
                                                  .licenseInfo
                                                  ?.accountInfo
                                                  ?.userInfo
                                                  .name !=
                                              null &&
                                          state
                                              .licenseInfo!
                                              .accountInfo!
                                              .userInfo
                                              .name!
                                              .isNotEmpty
                                      ? UserInfoItem(
                                        icon: SvgPicture.asset(
                                          'assets/icons/svg/person.svg',
                                        ),
                                        label: AppLocalizations.of(
                                          context,
                                        ).translate('Họ và tên'),
                                        value:
                                            state
                                                .licenseInfo!
                                                .accountInfo!
                                                .userInfo
                                                .name!,
                                      )
                                      : const SizedBox.shrink(),
                                  state
                                                  .licenseInfo
                                                  ?.accountInfo
                                                  ?.userInfo
                                                  .email !=
                                              null &&
                                          state
                                              .licenseInfo!
                                              .accountInfo!
                                              .userInfo
                                              .email!
                                              .isNotEmpty
                                      ? UserInfoItem(
                                        icon: SvgPicture.asset(
                                          'assets/icons/svg/message.svg',
                                        ),
                                        label: AppLocalizations.of(
                                          context,
                                        ).translate('Email'),
                                        value:
                                            state
                                                .licenseInfo!
                                                .accountInfo!
                                                .userInfo
                                                .email!,
                                      )
                                      : const SizedBox.shrink(),
                                  state
                                                  .licenseInfo
                                                  ?.accountInfo
                                                  ?.userInfo
                                                  .phone !=
                                              null &&
                                          state
                                              .licenseInfo!
                                              .accountInfo!
                                              .userInfo
                                              .phone!
                                              .isNotEmpty
                                      ? UserInfoItem(
                                        icon: const Icon(
                                          Icons.call_outlined,
                                          color: AppTheme.successColor,
                                        ),
                                        label: AppLocalizations.of(
                                          context,
                                        ).translate('SDT'),
                                        value:
                                            state
                                                .licenseInfo!
                                                .accountInfo!
                                                .userInfo
                                                .phone!,
                                      )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),

                            Positioned(
                              top: -22,
                              left: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: const Color(0xFFFFEECC),
                                  ),
                                  color: const Color(0xFFFFA800),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.md,
                                    vertical: Spacing.sm,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate('Thông tin tài khoản'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: Spacing.xxl),

                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: DashedBorder.fromBorderSide(
                            dashLength: 8,
                            side: BorderSide(
                              color: AppTheme.lightGrayColor,
                              width: 2,
                            ),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.lg,
                                horizontal: Spacing.md,
                              ),
                              child: Wrap(
                                spacing: Spacing.md,
                                runSpacing: Spacing.sm,
                                children:
                                    state.licenseInfo?.accountInfo?.profiles !=
                                            null
                                        ? state
                                            .licenseInfo!
                                            .accountInfo!
                                            .profiles
                                            .map(
                                              (profile) => Column(
                                                children: [
                                                  ClipOval(
                                                    child: Image.asset(
                                                      'assets/images/max_liked.png',
                                                      width: 48,
                                                      height: 48,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text(
                                                    profile.name,
                                                    style: const TextStyle(
                                                      color:
                                                          AppTheme
                                                              .textSecondaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList()
                                        : [],
                              ),
                            ),

                            Positioned(
                              top: -22,
                              left: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: const Color(0xFFE9F4D7),
                                  ),
                                  color: const Color(0xFF92C73D),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.md,
                                    vertical: Spacing.sm,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate('Hồ sơ học tập'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: Spacing.lg),
                      Text(
                        AppLocalizations.of(context).translate(
                          '* Tài khoản này được ghi nhận đã đăng nhập lần cuối trên thiết bị của bạn.',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const Spacer(),

                      AppButton.primary(
                        text: AppLocalizations.of(
                          context,
                        ).translate('Liên kết với tài khoản này'),
                        onPressed: () {
                          context
                              .read<ActiveLicenseCubit>()
                              .activateOnLastLoginAccount(true);
                        },
                      ),
                      const SizedBox(height: Spacing.md),
                      AppButton.secondary(
                        text: AppLocalizations.of(
                          context,
                        ).translate('Sử dụng tài khoản khác'),
                        onPressed: () {
                          context.push(AppRoutePaths.activeLicenseInputPhone);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            state.isLoading ? const LoadingOverlay() : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  void _showMergeLifetimeWarningListener(
    BuildContext context,
    ActiveLicenseState state,
  ) {
    showPopupWarningMergeLifetimeToPaid(
      context: context,
      onContinue: () {
        context.read<ActiveLicenseCubit>().activateOnLastLoginAccount(false);
        context.read<ActiveLicenseCubit>().closeMergeLifetimeWarning();
        context.pop();
      },
      onCancel: () {
        context.read<ActiveLicenseCubit>().closeMergeLifetimeWarning();
        context.pop();
      },
    );
  }
}

class UserInfoItem extends StatelessWidget {
  const UserInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: Spacing.sm),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text.rich(
                  TextSpan(
                    text: '$label: ',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.textGrayLightColor,
                    ),
                    children: [
                      TextSpan(
                        text: value,
                        style: const TextStyle(color: AppTheme.textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
      ],
    );
  }
}
