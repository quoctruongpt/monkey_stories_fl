import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrientationLoading extends StatefulWidget {
  const OrientationLoading({super.key});

  @override
  State<OrientationLoading> createState() => _OrientationLoadingState();
}

class _OrientationLoadingState extends State<OrientationLoading> {
  // Thời gian animation
  static const Duration _animationDuration = Duration(milliseconds: 300);

  // Giá trị animation
  static const double _initialBorderRadius = 30.0;
  static const double _finalBorderRadius = 0.0;
  static const double _initialScale = 0.9;
  static const double _finalScale = 1.0;

  double _borderRadius = _initialBorderRadius;
  double _scale = _initialScale;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _borderRadius = _finalBorderRadius;
        _scale = _finalScale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _initialBorderRadius, end: _borderRadius),
      duration: _animationDuration,
      curve: Curves.easeInOut,
      builder: (context, borderRadiusValue, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: _initialScale, end: _scale),
          duration: _animationDuration,
          curve: Curves.easeInOut,
          builder: (context, scaleValue, child) {
            return Transform.scale(
              scale: scaleValue,
              child: AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                ),
                child: Center(
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Lottie.asset(
                      'assets/lottie/rotate.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
