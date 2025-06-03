import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/profile/add_profile_item.dart';
import 'package:monkey_stories/presentation/widgets/profile/profile_item.dart';
import 'package:monkey_stories/presentation/widgets/parent_verify.dart';
import 'package:monkey_stories/presentation/bloc/dialog/dialog_cubit.dart';
import 'package:logging/logging.dart';

final logger = Logger('ListProfileDialog');

class ListProfileDialog extends StatelessWidget {
  final VoidCallback onClose;
  const ListProfileDialog({super.key, required this.onClose});

  void _settingPressed(BuildContext context) {
    context.read<DialogCubit>().showDialog(
      buildVerifyDialogWidget(
        context: context,
        onSuccess: () {
          navigatorKey.currentContext?.go(AppRoutePaths.report);
          onClose();
        },
      ),
    );
  }

  void _addProfilePressed(BuildContext context) {
    context.read<DialogCubit>().showDialog(
      buildVerifyDialogWidget(
        context: context,
        onSuccess: () {
          navigatorKey.currentContext?.pushNamed(
            AppRouteNames.createProfileInputName,
            queryParameters: {'source': 'add_profile'},
          );
          onClose();
        },
      ),
    );
  }

  void _profilePressed(BuildContext context, int profileId) {
    context.read<ProfileCubit>().selectProfile(profileId);
    onClose();
  }

  void _downloadedPressed(BuildContext context) {
    context.read<DialogCubit>().showDialog(
      buildVerifyDialogWidget(
        context: context,
        onSuccess: () {
          navigatorKey.currentContext?.push(AppRoutePaths.home);
          onClose();
        },
      ),
    );
  }

  void _activeLicensePressed(BuildContext context) {
    context.read<DialogCubit>().showDialog(
      buildVerifyDialogWidget(
        context: context,
        onSuccess: () {
          navigatorKey.currentContext?.push(AppRoutePaths.inputLicense);
          onClose();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                spreadRadius: -10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            AppLocalizations.of(
              context,
            ).translate('app.list_profile_dialog.title'),
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
                                        .maxProfile)
                                ? AddProfileItem(
                                  onTap: () => _addProfilePressed(context),
                                )
                                : const SizedBox.shrink())
                            : ProfileItem(
                              name: state.profiles[index].name,
                              avatar:
                                  state.profiles[index].localAvatarPath ??
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
            ).translate('app.list_profile.input_license_button'),
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
              ).translate('app.list_profile_dialog.downloaded_button'),
              icon: 'assets/icons/svg/downloaded.svg',
              onPressed: () => _downloadedPressed(context),
            ),
            const SizedBox(width: 8),
            Action(
              title: AppLocalizations.of(
                context,
              ).translate('app.list_profile_dialog.parent_button'),
              icon: 'assets/icons/svg/parent.svg',
              onPressed: () => _settingPressed(context),
            ),
          ],
        ),
      ],
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

// Khôi phục hàm này để UnityScreen sử dụng
Widget buildListProfileDialogWidget(BuildContext context) {
  final dialogKey = UniqueKey();

  // Hàm đóng dialog dùng chung trong phạm vi này
  void closeDialog() {
    // Sử dụng context gốc đã lưu để tìm DialogCubit
    // Giả định context này vẫn hợp lệ khi closeDialog được gọi
    try {
      BlocProvider.of<DialogCubit>(
        context,
        listen: false,
      ).dismissDialogByKey(dialogKey);
    } catch (e) {
      logger.severe('Error dismissing ListProfileDialog: $e');
    }
  }

  return Material(
    key: dialogKey, // Gán key để DialogCubit quản lý
    color: Colors.black54,
    child: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Truyền hàm closeDialog vào ListProfileDialog
              ListProfileDialog(onClose: closeDialog),
              Positioned(
                right: -14,
                top: -10,
                child: IconButton(
                  // Nút X này cũng gọi hàm đóng dialog
                  onPressed: closeDialog,
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
    ),
  );
}
