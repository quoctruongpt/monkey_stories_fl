import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/domain/entities/purchased/purchased_entity.dart';
import 'package:monkey_stories/presentation/bloc/purchased_view/purchased_view_cubit.dart';

class PackageItem extends StatefulWidget {
  const PackageItem({
    super.key,
    required this.package,
    required this.isSelected,
  });

  final PurchasedPackage package;
  final bool isSelected;

  @override
  State<PackageItem> createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _translateAnimation;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.package.isBestSeller) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      )..repeat(reverse: true);

      _translateAnimation = TweenSequence<double>([
        TweenSequenceItem(tween: Tween<double>(begin: 0, end: -5), weight: 1),
        TweenSequenceItem(tween: Tween<double>(begin: -5, end: 0), weight: 1),
      ]).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
      );

      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.05),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.05, end: 1.0),
          weight: 1,
        ),
      ]).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.read<PurchasedViewCubit>().selectPackage(widget.package);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(widget.isSelected ? 0xFFFFFFFF : 0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(widget.isSelected ? 0xFF00AAFF : 0xFFF2F4F7),
                    width: 4,
                  ),
                ),
                padding: const EdgeInsets.all(Spacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                ).translate(widget.package.name),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: Spacing.md),
                              widget.package.appliedSaleOff > 0
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF4BA1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.sm,
                                      vertical: Spacing.xs,
                                    ),
                                    child: Text(
                                      '- ${(widget.package.appliedSaleOff * 100).toStringAsFixed(0)}%',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.backgroundColor,
                                      ),
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          widget.package.canUseTrial
                              ? Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('app.purchased.trial_info'),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textGrayColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        widget.package.appliedSaleOff > 0
                            ? Text(
                              widget.package.localOriginalPrice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF424242),
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                            : const SizedBox.shrink(),
                        Text(
                          widget.package.priceDisplay,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.package.isBestSeller &&
                      _translateAnimation != null &&
                      _scaleAnimation != null &&
                      _controller != null
                  ? Positioned(
                    top: -16,
                    right: -4,
                    child: AnimatedBuilder(
                      animation: _controller!,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _translateAnimation!.value),
                          child: Transform.scale(
                            scale: _scaleAnimation!.value,
                            child: child,
                          ),
                        );
                      },
                      child: RotationTransition(
                        turns: const AlwaysStoppedAnimation(0.01),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.sm,
                            vertical: Spacing.xs,
                          ),
                          child: Text(
                            AppLocalizations.of(
                              context,
                            ).translate('app.purchased.best_seller'),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.backgroundColor),
                          ),
                        ),
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
      ],
    );
  }
}
