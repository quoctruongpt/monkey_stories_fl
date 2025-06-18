import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/core/utils/lottie_utils.dart';

/// A reusable loading overlay widget that displays a semi-transparent barrier
/// and a centered CircularProgressIndicator.
class LoadingOverlay extends StatefulWidget {
  final Color barrierColor;
  final bool dismissible;

  const LoadingOverlay({
    super.key,
    this.barrierColor = Colors.black38, // Default semi-transparent black
    this.dismissible = false,
  });

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ModalBarrier to dim the background and block taps
        ModalBarrier(
          dismissible: widget.dismissible,
          color: widget.barrierColor,
        ),
        // Centered CircularProgressIndicator
        Center(
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: LottieBuilder.asset(
                  'assets/lottie/loading.lottie',
                  width: 50,
                  height: 50,
                  decoder: customDecoder,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
