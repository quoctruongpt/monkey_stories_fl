import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/profile/add_profile_item.dart';
import 'package:monkey_stories/presentation/widgets/profile/profile_item.dart';
import 'package:monkey_stories/presentation/widgets/parent_verify.dart';

class ListProfileDialog extends StatelessWidget {
  const ListProfileDialog({super.key});

  void _settingPressed(BuildContext context) {
    showVerifyDialog(
      context: context,
      onSuccess: () {
        context.push(AppRoutePaths.home);
      },
    );
  }

  void _addProfilePressed(BuildContext context) {
    showVerifyDialog(
      context: context,
      onSuccess: () {
        context.push(AppRoutePaths.createProfileInputName);
      },
    );
  }

  void _profilePressed(BuildContext context, int profileId) {
    context.read<ProfileCubit>().selectProfile(profileId);
    context.push(AppRoutePaths.home);
  }

  void _downloadedPressed(BuildContext context) {
    showVerifyDialog(
      context: context,
      onSuccess: () {
        context.push(AppRoutePaths.home);
      },
    );
  }

  void _activeLicensePressed(BuildContext context) {
    showVerifyDialog(
      context: context,
      onSuccess: () {
        context.push(AppRoutePaths.inputLicense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: -10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('Bé nào đang học nhỉ?'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.azureColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 167, // Chiều cao cố định cho danh sách
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.profiles.length + 1,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 132,
                              margin: const EdgeInsets.only(right: 10.0),
                              child:
                                  (index == state.profiles.length)
                                      ? (state.profiles.length <
                                              (context
                                                      .read<UserCubit>()
                                                      .state
                                                      .user!
                                                      .maxProfile ??
                                                  0)
                                          ? AddProfileItem(
                                            onTap:
                                                () =>
                                                    _addProfilePressed(context),
                                          )
                                          : const SizedBox.shrink())
                                      : ProfileItem(
                                        name: state.profiles[index].name,
                                        avatar:
                                            state.profiles[index].avatarPath,
                                        onTap:
                                            () => _profilePressed(
                                              context,
                                              state.profiles[index].id,
                                            ),
                                        isActive:
                                            state.currentProfile?.id ==
                                            state.profiles[index].id,
                                      ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () => _activeLicensePressed(context),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('Nhập mã kích hoạt'),
                      style: const TextStyle(
                        color: Color(0xFF98A2B3),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Action(
                        title: AppLocalizations.of(
                          context,
                        ).translate('Mục đã tải'),
                        icon: 'assets/icons/svg/downloaded.svg',
                        onPressed: () => _downloadedPressed(context),
                      ),
                      const SizedBox(width: 8),
                      Action(
                        title: AppLocalizations.of(
                          context,
                        ).translate('Dành cho ba mẹ'),
                        icon: 'assets/icons/svg/parent.svg',
                        onPressed: () => _settingPressed(context),
                      ),
                    ],
                  ),
                ],
              ),

              Positioned(
                right: -14,
                top: -10,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 30,
                    color: Color(0xFFD0D5DD),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Action extends StatelessWidget {
  const Action({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
          padding: const EdgeInsets.all(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 24, height: 24),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF61646C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showListProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const ListProfileDialog(),
  );
}
