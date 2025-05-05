import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/lottie_utils.dart';

class CreateProfileHeader extends StatelessWidget {
  const CreateProfileHeader({super.key, this.title = ''});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Lottie.asset(
          'assets/lottie/monkey_write.lottie',
          decoder: customDecoder,
          width: 148,
          height: 168,
        ),
        const SizedBox(width: Spacing.sm),
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayMedium,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
