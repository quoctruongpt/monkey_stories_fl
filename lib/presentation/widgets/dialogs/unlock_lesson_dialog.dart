// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:monkey_stories/core/localization/app_localizations.dart';
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

class _Marquee extends StatefulWidget {
  const _Marquee({
    required this.child,
    this.reverse = false,
    this.duration = const Duration(seconds: 15),
    this.gap = 4.0,
  });

  final Widget child;
  final bool reverse;
  final Duration duration;
  final double gap;

  @override
  State<_Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<_Marquee> {
  late final ScrollController _controller;
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postFrameCallback();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _postFrameCallback() {
    if (!mounted) {
      return;
    }
    final context = _childKey.currentContext;
    final box = context?.findRenderObject() as RenderBox?;

    if (box == null || !box.hasSize || box.size.width == 0) {
      // Widget not laid out yet. Wait a bit and try again.
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _postFrameCallback();
        }
      });
      return;
    }

    final childWidth = box.size.width;
    final viewportWidth = _controller.position.viewportDimension;
    if (childWidth <= viewportWidth) {
      return;
    }
    final scrollDistance = childWidth + widget.gap;
    if (widget.reverse) {
      _controller.jumpTo(scrollDistance);
    }
    _scroll(scrollDistance);
  }

  Future<void> _scroll(double scrollDistance) async {
    while (_controller.hasClients) {
      if (widget.reverse) {
        await _controller.animateTo(
          0,
          duration: widget.duration,
          curve: Curves.linear,
        );
        if (!_controller.hasClients) break;
        _controller.jumpTo(scrollDistance);
      } else {
        await _controller.animateTo(
          scrollDistance,
          duration: widget.duration,
          curve: Curves.linear,
        );
        if (!_controller.hasClients) break;
        _controller.jumpTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          Container(key: _childKey, child: widget.child),
          SizedBox(width: widget.gap),
          widget.child,
        ],
      ),
    );
  }
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
                      AppLocalizations.of(
                        context,
                      ).translate('app.audio_book.unlock_lesson_dialog.title'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildThumbnails(),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).translate(
                        'app.audio_book.unlock_lesson_dialog.description',
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildUnlockButton(context)],
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
      child: Column(
        children: [
          _Marquee(
            child: Image.asset(
              'assets/images/payment_popup_1.png',
              height: 87,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
          const SizedBox(height: 4),
          _Marquee(
            reverse: true,
            child: Image.asset(
              'assets/images/payment_popup_2.png',
              height: 87,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockButton(BuildContext context) {
    return AppButton.primary(
      text: AppLocalizations.of(
        context,
      ).translate('app.audio_book.unlock_lesson_dialog.unlock_all'),
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
