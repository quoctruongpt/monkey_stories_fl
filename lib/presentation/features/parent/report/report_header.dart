import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/presentation/features/list_profile.dart';
import 'package:monkey_stories/presentation/widgets/profile/avatar.dart';
import 'package:monkey_stories/presentation/widgets/purchase/drag_handle.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({
    super.key,
    required this.profile,
    required this.profiles,
    required this.onSelectProfile,
  });

  final ProfileEntity profile;
  final List<ProfileEntity> profiles;
  final Function(ProfileEntity) onSelectProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 132,
          height: 132,
          child: Avatar(
            avatar: profile.avatarPath,
            randomColor: AvatarColor.green,
          ),
        ),
        const SizedBox(width: Spacing.md),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                AppLocalizations.of(context).translate(
                  'Đã tham gia:',
                  params: {
                    'date': DateFormat('MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        profile.timeCreated * 1000,
                      ),
                    ),
                  },
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textGrayLightColor,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 150.0),
                child: OutlinedButton(
                  onPressed: () {
                    _showListProfile(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textGrayLightColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context).translate('Đổi hồ sơ')),
                      const SizedBox(width: Spacing.sm),
                      const Icon(Icons.keyboard_arrow_down, size: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showListProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Spacing.lg)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.md),
            const DragHandle(),
            const SizedBox(height: Spacing.md),
            Text('Đổi hồ sơ', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: Spacing.md),
            const Divider(
              color: AppTheme.buttonPrimaryDisabledBackground,
              height: 1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.md,
                  horizontal: Spacing.md,
                ),
                child: ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final itemProfile = profiles[index];
                    final bool isSelected = itemProfile.id == profile.id;
                    return InkWell(
                      onTap: () {
                        onSelectProfile(itemProfile);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.md,
                          horizontal: Spacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.grey[200]
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Avatar(
                                avatar: itemProfile.avatarPath,
                                isShowBorder: false,
                              ),
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemProfile.name,
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displaySmall,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).translate(
                                      'Started from ${DateFormat('MMMM yyyy', AppLocalizations.of(context).locale.languageCode).format(DateTime.fromMillisecondsSinceEpoch(itemProfile.timeCreated * 1000))}',
                                      params: {
                                        'date': DateFormat(
                                          'MMMM yyyy',
                                          AppLocalizations.of(
                                            context,
                                          ).locale.languageCode,
                                        ).format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            itemProfile.timeCreated * 1000,
                                          ),
                                        ),
                                      },
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textGrayLightColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
