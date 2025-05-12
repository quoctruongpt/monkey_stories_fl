import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';

import 'package:monkey_stories/presentation/widgets/parent_verify.dart';
import 'package:monkey_stories/presentation/widgets/profile/add_profile_item.dart';
import 'package:monkey_stories/presentation/widgets/profile/profile_item.dart';

enum AvatarColor { blue, pink, green }

class ListProfile extends StatelessWidget {
  const ListProfile({super.key});

  void _settingPressed(BuildContext context) {
    showVerifyDialog(
      context: context,
      onSuccess: () {
        context.push(AppRoutePaths.home);
      },
    );
  }

  void _addProfilePressed(BuildContext context) {
    context.push(AppRoutePaths.createProfileInputName);
  }

  void _profilePressed(BuildContext context, int profileId) {
    context.read<ProfileCubit>().selectProfile(profileId);
    context.push(AppRoutePaths.unity);
  }

  void _showCreateProfileDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(context).translate('Thông báo'),
      messageText: AppLocalizations.of(
        context,
      ).translate('Bạn cần tạo hồ sơ học tập trước khi bắt đầu!'),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(context).translate('Tạo hồ sơ'),
      onPrimaryAction: () {
        context.push(AppRoutePaths.createProfileInputName);
      },
      isCloseable: false,
      canPopOnBack: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context).translate('Hồ sơ học tập'),
        actions: [
          IconButton(
            onPressed: () => _settingPressed(context),
            icon: SvgPicture.asset(
              'assets/icons/svg/setting.svg',
              width: 40,
              height: 40,
            ),
          ),
        ],
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
              Flexible(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    // Kiểm tra và hiển thị dialog nếu danh sách profile rỗng
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (state.profiles.isEmpty) {
                        _showCreateProfileDialog(context);
                      }
                    });

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Xác định số cột dựa trên chiều rộng màn hình
                        final crossAxisCount =
                            constraints.maxWidth > 600 ? 4 : 2;

                        final width =
                            (constraints.maxWidth - 20 * (crossAxisCount + 2)) /
                            crossAxisCount;

                        return Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  crossAxisCount * (132 + 20) +
                                  20, // 132 là width của item, 20 là spacing
                            ),
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                alignment: WrapAlignment.center,
                                children: [
                                  ...state.profiles.map(
                                    (profile) => SizedBox(
                                      width: width,
                                      child: ProfileItem(
                                        name: profile.name,
                                        avatar: profile.avatarPath,
                                        isActive:
                                            state.currentProfile?.id ==
                                            profile.id,
                                        onTap:
                                            () => _profilePressed(
                                              context,
                                              profile.id,
                                            ),
                                      ),
                                    ),
                                  ),

                                  if (state.profiles.length <
                                      context
                                          .read<UserCubit>()
                                          .state
                                          .user!
                                          .maxProfile)
                                    SizedBox(
                                      width: width,
                                      child: AddProfileItem(
                                        onTap:
                                            () => _addProfilePressed(context),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(AppRoutePaths.inputLicense);
                },
                child: Text(
                  AppLocalizations.of(context).translate('Nhập mã kích hoạt'),
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
