import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

void showUnlockLessonDialog({
  required BuildContext context,
  required VoidCallback onUnlock,
  required VoidCallback onClose,
}) {
  showDialog(
    context: context,
    builder:
        (context) => UnlockLessonDialog(onClose: onClose, onUnlock: onUnlock),
    barrierDismissible: false,
  );
}

class UnlockLessonDialog extends StatelessWidget {
  final VoidCallback? onUnlock;
  final VoidCallback? onClose;

  const UnlockLessonDialog({super.key, this.onUnlock, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60),
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bài học mới cực thú vị đang bị khóa!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildThumbnails(),
                    const SizedBox(height: 16),
                    Text(
                      'Khi con tò mò lắm rồi – ba mẹ cùng bé mở khóa nào!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildUnlockButton()],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close,
                    size: 40,
                    color: Color(0xFFD0D5DD),
                  ),
                ),
              ),
              Positioned(
                bottom: -6,
                left: -50,
                child: Image.asset('assets/images/max_unlock.png', width: 160),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnails() {
    // Placeholder images, replace with actual asset paths
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, 0.1, 0.9, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Image.asset(
        'assets/images/unlock_banner.png',
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildUnlockButton() {
    return AppButton.primary(
      text: 'Mở khóa toàn bộ',
      onPressed: onUnlock ?? () {},
      isFullWidth: false,
      icon: SvgPicture.asset(
        'assets/icons/svg/crown.svg',
        width: 42,
        height: 28,
      ),
    );
  }
}
