import 'package:flutter/material.dart';
import 'package:monkey_stories/data/models/audio_book/audio_book_item.dart';

class ThumbAudio extends StatelessWidget {
  const ThumbAudio({super.key, required this.track});

  final AudioBookItem? track;

  @override
  Widget build(BuildContext context) {
    // A placeholder to show when the track data is not available yet.
    final placeholder = Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260, maxHeight: 260),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(11.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            gradient: const LinearGradient(
              colors: [Color(0xFFB5E2FF), Color(0xFF0084FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: Colors.white.withOpacity(0.4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  track != null && track!.localThumbPath != null
                      ? Image.asset(
                        track!.localThumbPath!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => placeholder,
                      )
                      : placeholder,
            ),
          ),
        ),
      ),
    );
  }
}
