import 'dart:math';
import 'package:flutter/material.dart';
import 'package:monkey_stories/presentation/features/list_profile.dart';
import 'package:monkey_stories/presentation/widgets/profile/avatar.dart';

class ProfileItem extends StatefulWidget {
  const ProfileItem({
    super.key,
    required this.name,
    this.avatar,
    this.isActive = false,
    this.onTap,
  });

  final String name;
  final String? avatar;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  late final AvatarColor randomColor;

  @override
  void initState() {
    super.initState();
    randomColor =
        AvatarColor.values[Random().nextInt(AvatarColor.values.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                color: _backgroundColor,
                border:
                    widget.isActive
                        ? Border.all(width: 2, color: _activeColor)
                        : null,
              ),
              child: Avatar(avatar: widget.avatar, randomColor: randomColor),
            ),
          ),
          const SizedBox(height: 10),
          Text(widget.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    switch (randomColor) {
      case AvatarColor.blue:
        return const Color(0xFFDBF1FF);
      case AvatarColor.pink:
        return const Color(0xFFFFE8F3);
      default:
        return const Color(0xFFCAFFED);
    }
  }

  Color get _activeColor {
    switch (randomColor) {
      case AvatarColor.blue:
        return const Color(0xFF009AFF);
      case AvatarColor.pink:
        return const Color(0xFFFF4BA1);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}
