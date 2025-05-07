import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class ActiveLicensePhoneInfo extends StatelessWidget {
  const ActiveLicensePhoneInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveLicenseCubit, ActiveLicenseState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarWidget(
            title: AppLocalizations.of(
              context,
            ).translate('app.active_license.last_login_info.title'),
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
                    AppLocalizations.of(
                      context,
                    ).translate('app.active_license.phone_info.desc'),
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
                              state.phoneInfo?.userInfo.name != null &&
                                      state.phoneInfo!.userInfo.name!.isNotEmpty
                                  ? UserInfoItem(
                                    icon: SvgPicture.asset(
                                      'assets/icons/svg/person.svg',
                                    ),
                                    label: AppLocalizations.of(
                                      context,
                                    ).translate(
                                      'app.active_license.last_login_info.name',
                                    ),
                                    value: state.phoneInfo?.userInfo.name ?? '',
                                  )
                                  : const SizedBox.shrink(),
                              state.phoneInfo?.userInfo.email != null &&
                                      state
                                          .phoneInfo!
                                          .userInfo
                                          .email!
                                          .isNotEmpty
                                  ? UserInfoItem(
                                    icon: SvgPicture.asset(
                                      'assets/icons/svg/message.svg',
                                    ),
                                    label: AppLocalizations.of(
                                      context,
                                    ).translate(
                                      'app.active_license.last_login_info.email',
                                    ),
                                    value:
                                        state.phoneInfo?.userInfo.email ?? '',
                                  )
                                  : const SizedBox.shrink(),
                              state.phoneInfo?.userInfo.phone != null &&
                                      state
                                          .phoneInfo!
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
                                    ).translate(
                                      'app.active_license.last_login_info.phone',
                                    ),
                                    value:
                                        state.phoneInfo?.userInfo.phone ?? '',
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
                                AppLocalizations.of(context).translate(
                                  'app.active_license.last_login_info.account_info',
                                ),
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
                                state.phoneInfo?.profiles != null
                                    ? state.phoneInfo!.profiles
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
                                AppLocalizations.of(context).translate(
                                  'app.active_license.last_login_info.profile',
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  AppButton.primary(
                    text: AppLocalizations.of(context).translate(
                      'app.active_license.last_login_info.link_account',
                    ),
                    onPressed: () {
                      context.push(AppRoutePaths.activeLicenseInputPassword);
                    },
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton.secondary(
                    text: AppLocalizations.of(context).translate(
                      'app.active_license.last_login_info.use_other_account',
                    ),
                    onPressed: () {
                      context.replace(AppRoutePaths.activeLicenseInputPhone);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
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
