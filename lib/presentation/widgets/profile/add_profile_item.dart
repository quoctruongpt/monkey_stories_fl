import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddProfileItem extends StatelessWidget {
  final VoidCallback? onTap;
  const AddProfileItem({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                color: const Color(0xFFF2F4F7),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/svg/add.svg',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Thêm'),
        ],
      ),
    );
  }
}
