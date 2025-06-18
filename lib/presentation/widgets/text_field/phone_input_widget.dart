import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onCountryChange;
  final void Function(String)? onCountryInit;
  final String initialCountryCode;
  final bool? isLoading;
  final String? errorText;
  final bool? isPhoneValid;
  final String? labelText;
  final double? fontSize;
  final String? labelTopText;
  final Widget? labelTopIcon;
  final VoidCallback? onTap;
  final bool? canEdit;

  const PhoneInputField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onCountryChange,
    this.onCountryInit,
    this.initialCountryCode = 'VN',
    this.isLoading = false,
    this.errorText,
    this.isPhoneValid = false,
    this.labelText,
    this.fontSize = 20,
    this.labelTopText,
    this.labelTopIcon,
    this.onTap,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(
        absorbing: onTap != null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (labelTopText != null)
              Column(
                children: [
                  Row(
                    children: [
                      labelTopIcon ?? const SizedBox.shrink(),
                      const SizedBox(width: Spacing.sm),
                      Text(labelTopText!),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                ],
              ),
            TextField(
              enabled: canEdit,
              controller: controller,
              keyboardType: TextInputType.phone,
              onChanged: onChanged,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                labelText: labelText,
                hintText:
                    hintText ??
                    AppLocalizations.of(
                      context,
                    ).translate('sign_up.input_phone.hint'),
                hintStyle: TextStyle(
                  fontSize: fontSize,
                  color: AppTheme.textGrayLightColor,
                ),
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textGrayColor,
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                ),
                errorText: errorText?.isEmpty == true ? null : errorText,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: Spacing.md),
                  child: IntrinsicWidth(
                    child: CountryCodePicker(
                      initialSelection: initialCountryCode,
                      onChanged: (country) {
                        onCountryChange?.call(country.dialCode!);
                      },
                      onInit: (country) {
                        onCountryInit?.call(country?.dialCode ?? '');
                      },
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: true,
                      hideHeaderText: true,
                      alignLeft: true,
                      builder: (country) {
                        return Row(
                          children: [
                            if (country?.flagUri != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  country!.flagUri!,
                                  package: 'country_code_picker',
                                  width: 28,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const Icon(
                              Icons.expand_more_outlined,
                              color: AppTheme.textGrayLightColor,
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: AppTheme.textGrayLightColor,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            Text(
                              country?.dialCode ?? '',
                              style: Theme.of(
                                context,
                              ).textTheme.displaySmall?.copyWith(
                                fontSize: fontSize,
                                color:
                                    canEdit != true
                                        ? AppTheme.textGrayLightColor
                                        : null,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                suffix:
                    isLoading == true
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                        : null,
                suffixIcon:
                    isPhoneValid == true
                        ? const Icon(
                          Icons.check_circle,
                          size: 24,
                          color: AppTheme.successColor,
                        )
                        : null,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.textGrayLightColor),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        isPhoneValid == true
                            ? AppTheme.successColor
                            : AppTheme.textGrayLightColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        isPhoneValid == true
                            ? AppTheme.successColor
                            : AppTheme.textGrayLightColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.errorColor),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.errorColor),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorMaxLines: 2,
              ),
            ),

            const SizedBox(height: Spacing.sm),

            isPhoneValid == true
                ? Text(
                  AppLocalizations.of(context).translate('sign_up.phone.valid'),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
