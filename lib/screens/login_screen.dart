import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/widgets/button_widget.dart';
import 'package:monkey_stories/widgets/horizontal_line_text.dart';
import 'package:monkey_stories/widgets/text_and_action.dart';

// Custom decoder to select the correct JSON file from a .lottie archive
Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      // Adjust the logic here if your .json file has a different path/name pattern
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // TODO: Handle back navigation
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            // Allows scrolling if content overflows
            child: Padding(
              padding: const EdgeInsets.only(
                left: Spacing.lg,
                right: Spacing.lg,
                top: Spacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Lottie.asset(
                    'assets/lottie/monkey_hello.lottie',
                    decoder: customDecoder,
                    width: 151,
                    height: 169,
                  ),

                  const SizedBox(height: Spacing.sm),

                  TextField(
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại/Tên đăng nhập',
                    ),
                  ),

                  const SizedBox(height: Spacing.sm),

                  TextField(
                    onChanged: (value) {},
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  ),

                  const SizedBox(height: Spacing.sm),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Device ID: 100600', // Replace with dynamic Device ID if needed
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textGrayLightColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Quên mật khẩu?",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppTheme.textSecondaryColor),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Spacing.md),

                  AppButton.primary(
                    text: "Đăng nhập",
                    onPressed: () {},
                    isFullWidth: true,
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextAndAction(
                      text: 'Nếu bạn có mã kích hoạt, ',
                      actionText: 'Nhập tại đây.',
                      onActionTap: () {},
                    ),
                  ),

                  const SizedBox(height: Spacing.xxl),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Spacing.md),
                    child: HorizontalLineText(text: "Hoặc đăng nhập với"),
                  ),

                  const SizedBox(height: Spacing.xl),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          Colors.blue.shade700,
                          Icons.facebook,
                          () {
                            /* TODO: Handle Facebook Login */
                          },
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: _buildSocialButton(
                          Colors.white,
                          Icons.access_alarm_outlined,
                          () {
                            /* TODO: Handle Google Login */
                          },
                          isGoogle: true,
                        ),
                      ), // Placeholder icon
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: _buildSocialButton(
                          Colors.black,
                          Icons.apple,
                          () {
                            /* TODO: Handle Apple Login */
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Spacing.lg),

                  Center(
                    child: TextAndAction(
                      text: 'Bạn chưa có tài khoản? ',
                      actionText: 'Đăng ký',
                      onActionTap: () {},
                    ),
                  ),
                  const SizedBox(height: 20), // Add some padding at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    Color backgroundColor,
    IconData iconData,
    VoidCallback onPressed, {
    bool isGoogle = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: isGoogle ? Colors.black : Colors.white, // Icon color
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
        ), // Adjust padding as needed
        minimumSize: const Size(60, 40), // Adjust size as needed
        elevation: 1,
      ),
      child:
          isGoogle
              ? SvgPicture.asset(
                // Placeholder for Google Logo
                'assets/icons/svg/google.svg',
                semanticsLabel: 'Google Logo',
                height: 24,
                width: 24,
              )
              : Icon(iconData, size: 24), // Adjust icon size as needed
    );
  }
}
