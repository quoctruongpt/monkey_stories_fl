import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.onBackPressed,
    this.leading,
    this.title,
    this.showBackButton = true,
    this.actions,
  });

  final VoidCallback? onBackPressed;
  final Widget? leading;
  final String? title;
  final bool? showBackButton;
  final List<Widget>? actions;

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
          (canGoBack == true && widget.showBackButton == true
              ? IconButton(
                onPressed: handleBackPressed,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.textColor,
                ),
              )
              : null),
      actions: widget.actions,
      title:
          widget.title != null
              ? Text(
                widget.title!,
                style: Theme.of(context).textTheme.displaySmall,
              )
              : null,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    );
  }
}
