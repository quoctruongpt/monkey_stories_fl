// lib/widgets/setting_item_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/data/models/setting/setting_item.dart';
import 'package:monkey_stories/domain/usecases/tracking/setting/ms_parent_setting_detail.dart';
import 'package:monkey_stories/di/usecases.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

class SettingItemWidget extends StatelessWidget {
  final SettingItem item;

  const SettingItemWidget({super.key, required this.item});

  void _onTap(BuildContext context) {
    if (item.clickType != null) {
      final hasEmail =
          context.read<UserCubit>().state.user?.email?.isNotEmpty ?? false;
      final hasPhone =
          context.read<UserCubit>().state.user?.phone?.isNotEmpty ?? false;
      sl<MsParentSettingDetailTrackingUsecase>().call(
        MsParentSettingDetailParams(
          clickType: item.clickType!,
          hasEmail: hasEmail,
          hasPhone: hasPhone,
        ),
      );
    }

    if (item.route != null) {
      context.pushNamed(item.route!);
    } else if (item.onTap != null) {
      item.onTap!(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: SvgPicture.asset(item.icon, width: 24, height: 24),
      title: Text(
        AppLocalizations.of(context).translate(item.label),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppTheme.textColor,
        ),
      ),
      trailing:
          item.showArrow
              ? const Icon(Icons.arrow_forward_ios, size: 20)
              : item.valueGetter != null
              ? FutureBuilder<String?>(
                future: item.valueGetter!(),
                builder: (context, snapshot) {
                  return SelectableText(
                    snapshot.data ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textGrayLightColor,
                    ),
                  );
                },
              )
              : null,
      onTap: () => _onTap(context),
    );
  }
}
