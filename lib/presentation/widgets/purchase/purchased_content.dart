import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class PurchasedContentItem {
  final String text;
  final String? tag;

  const PurchasedContentItem({required this.text, this.tag});
}

class PurchasedContent extends StatelessWidget {
  const PurchasedContent({super.key, required this.listContent});

  final List<PurchasedContentItem> listContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...listContent.map(
          (e) => Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.azureColor,
                    size: 24,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(
                              context,
                            ).translate(e.text),
                          ),
                          if (e.tag != null)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                margin: const EdgeInsets.only(left: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4BA1),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Text(
                                  e.tag!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
            ],
          ),
        ),
      ],
    );
  }
}
