import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/profile/add_profile_item.dart';
import 'package:monkey_stories/presentation/widgets/profile/profile_item.dart';

enum AvatarColor { blue, pink, green }

class ListProfileSetting extends StatelessWidget {
  const ListProfileSetting({super.key});

  void _addProfilePressed(BuildContext context) {
    context.pushNamed(
      AppRouteNames.createProfileInputName,
      queryParameters: {'source': 'add_profile'},
    );
  }

  void _profilePressed(BuildContext context, int profileId) {
    context.pushNamed(
      AppRouteNames.editProfileInfo,
      queryParameters: {'profileId': profileId.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context).translate('app.list_profile.title'),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Spacing.md,
            right: Spacing.md,
            bottom: Spacing.lg,
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Xác định số cột dựa trên chiều rộng màn hình
                  final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

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
                                child: Hero(
                                  tag: 'profile_${profile.id}',
                                  child: ProfileItem(
                                    name: profile.name,
                                    avatar:
                                        profile.localAvatarPath ??
                                        profile.avatarPath,
                                    onTap:
                                        () => _profilePressed(
                                          context,
                                          profile.id,
                                        ),
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
                                  onTap: () => _addProfilePressed(context),
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
      ),
    );
  }
}
