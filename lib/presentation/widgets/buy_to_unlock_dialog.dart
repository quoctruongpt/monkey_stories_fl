import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuyToUnlockDialog extends StatelessWidget {
  final VoidCallback? onUnlock;

  const BuyToUnlockDialog({super.key, this.onUnlock});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 40, bottom: size.height * 0.05),
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xff005473),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildThumbnails(),
                const SizedBox(height: 16),
                Text(
                  'Khi con tò mò lắm rồi – ba mẹ cùng bé mở khóa nào!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xff4c4c4c),
                  ),
                ),
                const SizedBox(height: 24),
                _buildUnlockButton(),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset('assets/icons/svg/ic_close_circle.svg'),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset('assets/icons/svg/monkey_bottom.svg'),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnails() {
    // Placeholder images, replace with actual asset paths
    final thumbnails = [
      'assets/images/placeholder/thumb1.png',
      'assets/images/placeholder/thumb2.png',
      'assets/images/placeholder/thumb3.png',
      'assets/images/placeholder/thumb4.png',
      'assets/images/placeholder/thumb5.png',
      'assets/images/placeholder/thumb6.png',
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: thumbnails.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(thumbnails[index], fit: BoxFit.cover),
        );
      },
    );
  }

  Widget _buildUnlockButton() {
    return ElevatedButton(
      onPressed: onUnlock,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff00A9F4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: Builder(
        builder: (context) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mở khóa toàn bộ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset('assets/icons/svg/crown.svg'),
            ],
          );
        },
      ),
    );
  }
}
