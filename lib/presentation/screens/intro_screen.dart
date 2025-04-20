import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/button_widget.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 330),
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: 0.87,
                          child: Image.asset(
                            'assets/images/intro_header.png',
                            fit: BoxFit.cover,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate(
                            'Top 1 ứng dụng giúp con giỏi tiếng Anh chuẩn Mỹ trước 10 tuổi',
                          ),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: AppTheme.textPrimaryColor),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          AppLocalizations.of(context).translate(
                            'Học qua 1300+ truyện tr anh tương tác, 200+ sách nói – Nghe, nói, đọc, viết toàn diện.',
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/rice_flower_left.png',
                                  height: 60,
                                  width: 29,
                                ),
                                Text(
                                  '10 triệu phụ huynh\ntin dùng',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Image.asset(
                                  'assets/images/rice_flower_right.png',
                                  height: 60,
                                  width: 29,
                                ),
                              ],
                            ),
                            const SizedBox(width: Spacing.sm),
                            Image.asset(
                              'assets/images/kid_safe.png',
                              height: 49,
                              width: 174,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Column(
                children: [
                  AppButton.primary(
                    text: AppLocalizations.of(
                      context,
                    ).translate('Bắt đầu học thử'),
                    onPressed: () {},
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton.secondary(
                    text: AppLocalizations.of(context).translate('Đăng nhập'),
                    onPressed: () {},
                  ),
                  const SizedBox(height: Spacing.md),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('Nhập mã kích hoạt'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
