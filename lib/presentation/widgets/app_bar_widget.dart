import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, this.onBackPressed, this.leading});

  final VoidCallback? onBackPressed;
  final Widget? leading;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool? canGoBack = false;

  @override
  void initState() {
    super.initState();
    canGoBack = context.canPop();
  }

  void handleBackPressed() {
    if (widget.onBackPressed != null) {
      widget.onBackPressed!();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          widget.leading ??
          (canGoBack == true
              ? IconButton(
                onPressed: handleBackPressed,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.textColor,
                ),
              )
              : null),

      backgroundColor: Colors.transparent,
    );
  }
}
