import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/success_screen.dart';

class ActiveLicenseSuccess extends StatelessWidget {
  const ActiveLicenseSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveLicenseCubit, ActiveLicenseState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              body: SuccessScreen(
                title: AppLocalizations.of(
                  context,
                ).translate('Kích hoạt thành công'),
                descriptionWidget: Column(
                  children: [
                    const SizedBox(height: Spacing.lg),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('Chúc mừng ba mẹ đã kích hoạt khóa học'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    Text(
                      state.licenseInfo!.packageInfo.productName.isEmpty
                          ? state.licenseInfo!.packageInfo.courseName
                          : state.licenseInfo!.packageInfo.productName,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                buttonText: AppLocalizations.of(
                  context,
                ).translate('Hoàn thành'),
                onPressed: () {
                  context.read<ActiveLicenseCubit>().handleSuccess();
                },
              ),
            ),
            state.isLoading ? const LoadingOverlay() : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
