import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData? iconData; // Make nullable if using SVG for Google
  final String? googleIconAsset; // Specific asset for Google
  final VoidCallback? onPressed;
  final bool isGoogle;

  const SocialLoginButton({
    super.key,
    required this.backgroundColor,
    this.iconData,
    this.googleIconAsset,
    required this.onPressed,
    this.isGoogle = false,
  }) : assert(
         isGoogle ? googleIconAsset != null : iconData != null,
         'Either iconData or googleIconAsset must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor:
            isGoogle ? Colors.black : Colors.white, // Icon/SVG color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side:
              isGoogle
                  ? BorderSide(color: Colors.grey.shade300)
                  : BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        minimumSize: const Size(60, 40),
        elevation: 1,
        // Style differently when disabled
        disabledBackgroundColor:
            isDisabled ? backgroundColor.withOpacity(0.5) : backgroundColor,
        disabledForegroundColor:
            isDisabled
                ? (isGoogle ? Colors.black : Colors.white).withOpacity(0.5)
                : (isGoogle ? Colors.black : Colors.white),
      ),
      child:
          isGoogle && googleIconAsset != null
              ? SvgPicture.asset(
                googleIconAsset!,
                semanticsLabel: 'Google Logo',
                height: 24,
                width: 24,
                colorFilter:
                    isDisabled
                        ? ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.srcIn,
                        )
                        : null,
              )
              : Icon(
                iconData,
                size: 24,
                color: isDisabled ? Colors.white.withOpacity(0.5) : null,
              ),
    );
  }
}
