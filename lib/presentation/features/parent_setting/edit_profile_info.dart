import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/account/update_profile_info/update_profile_info_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/profile/avatar.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';
import 'package:monkey_stories/presentation/widgets/year_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monkey_stories/core/utils/permission.dart';
import 'package:monkey_stories/presentation/widgets/dialogs/permission_denied_dialog.dart';

class EditProfileInfo extends StatelessWidget {
  const EditProfileInfo({super.key, required this.profileId});

  final int profileId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UpdateProfileInfoCubit>(),
      child: EditProfileInfoView(profileId: profileId),
    );
  }
}

class EditProfileInfoView extends StatefulWidget {
  const EditProfileInfoView({super.key, required this.profileId});

  final int profileId;

  @override
  State<EditProfileInfoView> createState() => _EditProfileInfoViewState();
}

class _EditProfileInfoViewState extends State<EditProfileInfoView> {
  late TextEditingController nameController;
  late TextEditingController birthYearController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = context.read<UpdateProfileInfoCubit>().loadProfile(
      widget.profileId,
    );
    nameController = TextEditingController();
    nameController.text = profile?.name ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _showAgeChangeLimitDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(context).translate('app.notice'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.profile.age_change_limit'),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.understand'),
      onPrimaryAction: () {
        context.pop();
      },
    );
  }

  void _showAgeChangeWarningDialog(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(context).translate('app.warning'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.profile.age_change_warning'),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.i_am_sure'),
      onPrimaryAction: () {
        context.pop();
        context.read<UpdateProfileInfoCubit>().updateProfile();
      },
      secondaryActionText: AppLocalizations.of(context).translate('app.cancel'),
      onSecondaryAction: () {
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileInfoCubit, UpdateProfileInfoState>(
      listenWhen:
          (previous, current) =>
              previous.isSuccess != current.isSuccess ||
              previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.successColor,
              content: Text(
                AppLocalizations.of(
                  context,
                ).translate('app.profile.update_success'),
              ),
            ),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).translate(state.errorMessage),
              ),
              backgroundColor: AppTheme.errorColor,
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
                  title: AppLocalizations.of(context).translate(
                    'app.profile.title',
                    params: {'name': state.profile?.name ?? ''},
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 132,
                                height: 132,
                                child: Hero(
                                  tag: 'profile_${state.profile?.id}',
                                  child: Avatar(
                                    avatar: state.profile?.avatarPath,
                                  ),
                                ),
                              ),
                              Center(
                                child: TextButton(
                                  onPressed: _changeAvatar,
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        AppTheme.textSecondaryColor,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.photo_camera),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(context).translate(
                                          'app.profile.change_avatar',
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: AppTheme.buttonPrimaryDisabledBackground,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: Spacing.md,
                                  right: Spacing.md,
                                  top: Spacing.md,
                                  bottom: 24,
                                ),
                                child: Column(
                                  children: [
                                    TextFieldWidget(
                                      controller: nameController,
                                      onChanged: (value) {
                                        context
                                            .read<UpdateProfileInfoCubit>()
                                            .updateName(value);
                                      },
                                      labelTopText: AppLocalizations.of(
                                        context,
                                      ).translate('app.profile.name.label'),
                                      hintText: AppLocalizations.of(
                                        context,
                                      ).translate('app.profile.name.hint'),
                                      errorText: AppLocalizations.of(
                                        context,
                                      ).translate(
                                        state.isNameTaken
                                            ? 'app.create_profile.name.error_existed'
                                            : state.name.displayError,
                                      ),
                                      textCapitalization:
                                          TextCapitalization.words,
                                    ),
                                    const SizedBox(height: 16),
                                    YearSelector(
                                      years: state.years ?? [],
                                      onChangeYear: (year) {
                                        context
                                            .read<UpdateProfileInfoCubit>()
                                            .updateBirthYear(year);
                                      },
                                      yearSelected: state.birthYear,
                                      onSelectorPressed:
                                          context
                                                      .read<UserCubit>()
                                                      .state
                                                      .purchasedInfo
                                                      ?.isPaidUser ==
                                                  false
                                              ? () =>
                                                  showPermissionDeniedDialog(
                                                    context,
                                                  )
                                              : state.numberChangeAge >= 1
                                              ? () => _showAgeChangeLimitDialog(
                                                context,
                                              )
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(Spacing.md),
                        child: AppButton.primary(
                          text: AppLocalizations.of(
                            context,
                          ).translate('app.user_info.save'),
                          onPressed: () {
                            if (state.hasChangedAge) {
                              _showAgeChangeWarningDialog(context);
                            } else {
                              context
                                  .read<UpdateProfileInfoCubit>()
                                  .updateProfile();
                            }
                          },
                          disabled: !state.isButtonEnabled || state.isNameTaken,
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

  Future<void> _changeAvatar() async {
    final localizations = AppLocalizations.of(context);

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  child: Text(
                    localizations.translate('app.profile.change_avatar'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                    ), // Add padding to align icon with title
                    child: Icon(
                      Icons.camera_alt,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  title: Text(
                    localizations.translate('app.profile.take_photo'),
                    style: const TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                    ), // Add padding to align icon with title
                    child: Icon(
                      Icons.photo_library,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  title: Text(
                    localizations.translate('app.profile.choose_from_library'),
                    style: const TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    bool permissionGranted = false;
    if (source == ImageSource.camera) {
      if (mounted) {
        permissionGranted = await PermissionUtil.checkCameraPermission(context);
      }
    } else if (source == ImageSource.gallery) {
      if (mounted) {
        permissionGranted = await PermissionUtil.checkPhotoLibraryPermission(
          context,
        );
      }
    }

    if (!permissionGranted) return;

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (mounted) {
        context.read<UpdateProfileInfoCubit>().updateAvatar(pickedFile.path);
      }
    }
  }
}

class YearSelector extends StatelessWidget {
  const YearSelector({
    super.key,
    this.yearSelected,
    required this.years,
    required this.onChangeYear,
    this.onSelectorPressed,
  });

  final int? yearSelected;
  final List<int> years;
  final void Function(int year) onChangeYear;
  final void Function()? onSelectorPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            AppLocalizations.of(
              context,
            ).translate('app.profile.birth_year.label'),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onSelectorPressed ?? () => _showYearSelector(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.textGrayLightColor),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                yearSelected != null
                    ? Text(
                      yearSelected! > years.last
                          ? yearSelected.toString()
                          : AppLocalizations.of(context).translate(
                            'year.before',
                            params: {'year': years[12].toString()},
                          ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                    : Text(
                      AppLocalizations.of(
                        context,
                      ).translate('app.profile.birth_year.hint'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textGrayLightColor,
                      ),
                    ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showYearSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  const crossAxisCount = 4;
                  const spacing = Spacing.sm;
                  final totalSpacing = spacing * (crossAxisCount - 1);
                  final itemWidth =
                      (constraints.maxWidth - totalSpacing) / crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(
                      12,
                      (index) => SizedBox(
                        width: itemWidth,
                        child: buildYearButton(
                          context,
                          years[index],
                          yearSelected == years[index],
                          () {
                            onChangeYear(years[index]);
                            context.pop();
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: buildYearButton(
                  context,
                  years[12],
                  yearSelected != null && yearSelected! <= years[12],
                  () {
                    onChangeYear(years[12]);
                    Navigator.pop(context);
                  },
                  customText: AppLocalizations.of(context).translate(
                    'year.before',
                    params: {'year': years[12].toString()},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
