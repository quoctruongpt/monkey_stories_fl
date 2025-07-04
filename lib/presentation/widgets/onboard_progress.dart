import 'package:flutter/material.dart';

class OnboardProgress extends StatelessWidget {
  const OnboardProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final bool isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 8,
            decoration: BoxDecoration(
              color:
                  isActive
                      ? const Color(0xFF36BFFA)
                      : const Color(0xFF36BFFA).withAlpha(30),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
