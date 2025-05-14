import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monkey_stories/presentation/features/list_profile.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.avatar, this.randomColor});

  final String? avatar;
  final AvatarColor? randomColor;

  Widget _buildAvatar() {
    if (avatar == null) {
      return Image.asset('assets/images/avatar_default.png');
    }

    // Kiểm tra nếu là base64
    if (avatar!.startsWith('https://')) {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.network(
            avatar!,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/avatar_default.png');
            },
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        return Image.asset('assets/images/avatar_default.png');
      }
    }

    if (avatar!.startsWith('/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.file(
          File(avatar!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/avatar_default.png');
          },
        ),
      );
    }

    // Nếu không phải base64 thì xử lý như bình thường
    return Image.asset('assets/images/avatar_default.png');
  }

  Color get _borderColor {
    switch (randomColor) {
      case AvatarColor.blue:
        return const Color(0xFFC9DEEB);
      case AvatarColor.pink:
        return const Color(0xFFEBD5E0);
      default:
        return const Color(0xFFBAEBDA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 6, color: _borderColor),
        borderRadius: BorderRadius.circular(200),
      ),
      child: _buildAvatar(),
    );
  }
}
