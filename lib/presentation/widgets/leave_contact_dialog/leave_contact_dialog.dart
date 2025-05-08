import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/leave_contact.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/repositories.dart';
import 'package:monkey_stories/presentation/bloc/leave_contact/leave_contact_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/text_field/phone_input_widget.dart';

class LeaveContactDialog extends StatelessWidget {
  const LeaveContactDialog({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  void _onSuccess(BuildContext context) {
    Navigator.of(context).pop();
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.popup_c3.title.success'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.popup_c3.desc.success'),
      imageAsset: 'assets/images/max_liked.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.popup_c3.act.success'),
      titleColor: AppTheme.successColor,
      onPrimaryAction: onSuccess,
    );
  }

  void _onError(BuildContext context) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(
        context,
      ).translate('app.popup_c3.title.fail'),
      messageText: AppLocalizations.of(
        context,
      ).translate('app.popup_c3.desc.fail'),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(
        context,
      ).translate('app.popup_c3.act.fail'),
      onPrimaryAction: () {
        context.pop();
      },
      titleColor: AppTheme.errorColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaveContactCubit, LeaveContactState>(
      listenWhen:
          (previous, current) =>
              previous.isSuccess != current.isSuccess ||
              previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          _onSuccess(context);
        } else if (state.errorMessage != null) {
          _onError(context);
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior:
                Clip.none, // Cho phép ảnh tràn ra ngoài vùng Stack chính
            alignment: Alignment.topCenter, // Căn ảnh ở trên cùng giữa
            children: <Widget>[
              // Container chứa nội dung text và button
              Container(
                padding: const EdgeInsets.all(Spacing.lg),

                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('app.popup_c3.title'),
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('app.popup_c3.desc'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: Spacing.lg),

                    DropdownButtonFormField<LeaveContactRole>(
                      value: state.role,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(
                          context,
                        ).translate('app.popup_c3.role.label'),
                      ),
                      hint: Text(
                        AppLocalizations.of(
                          context,
                        ).translate('app.popup_c3.role.hint'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textGrayLightColor,
                        ),
                      ),
                      isExpanded: true,
                      items:
                          leaveContactRoles.map((LeaveContactRoleItem role) {
                            return DropdownMenuItem<LeaveContactRole>(
                              value: role.value,
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                ).translate(role.label),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        context.read<LeaveContactCubit>().roleChanged(value);
                      },
                    ),

                    const SizedBox(height: Spacing.md),

                    PhoneInputField(
                      labelText: AppLocalizations.of(
                        context,
                      ).translate('app.popup_c3.phone.title'),
                      onChanged: (value) {
                        context.read<LeaveContactCubit>().phoneChanged(value);
                      },
                      errorText: state.errorMessage,
                      onCountryChange: (value) {
                        context.read<LeaveContactCubit>().countryCodeChanged(
                          value,
                        );
                      },
                      initialCountryCode: 'VN',
                      onCountryInit: (value) {
                        context.read<LeaveContactCubit>().countryCodeInit(
                          value,
                        );
                      },
                      fontSize: 16,
                    ),

                    const SizedBox(height: Spacing.lg),
                    // Nút Primary
                    AppButton.primary(
                      text: AppLocalizations.of(
                        context,
                      ).translate('app.popup_c3.act'),
                      onPressed: () {
                        context.read<LeaveContactCubit>().submit();
                      },
                      isFullWidth: true,
                      disabled:
                          state.isSubmitting ||
                          !state.phone.isValid ||
                          state.role == null,
                      isLoading: state.isSubmitting,
                    ),
                  ],
                ),
              ),

              Positioned(
                right: -4, // Thêm padding từ mép dialog + padding container nút
                top: -4, // Thêm margin top container + padding container nút
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgPicture.asset(
                    'assets/icons/svg/X.svg',
                    width: 48,
                    height: 48,
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

void showLeaveContactDialog(BuildContext context, VoidCallback onSuccess) {
  showDialog(
    context: context,
    builder:
        (context) => BlocProvider(
          create: (context) => sl<LeaveContactCubit>(),
          child: LeaveContactDialog(onSuccess: onSuccess),
        ),
  );
}
