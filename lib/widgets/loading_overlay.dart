import 'package:flutter/material.dart';

/// A reusable loading overlay widget that displays a semi-transparent barrier
/// and a centered CircularProgressIndicator.
class LoadingOverlay extends StatelessWidget {
  final Color barrierColor;
  final bool dismissible;

  const LoadingOverlay({
    super.key,
    this.barrierColor = Colors.black38, // Default semi-transparent black
    this.dismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ModalBarrier to dim the background and block taps
        ModalBarrier(dismissible: dismissible, color: barrierColor),
        // Centered CircularProgressIndicator
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
