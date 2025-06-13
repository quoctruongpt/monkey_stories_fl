import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/presentation/bloc/audio_book/audio_book_cubit.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({super.key});

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  final ScrollController _scrollController = ScrollController();
  List<GlobalKey> _paragraphKeys = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToHighlightedSentence() {
    final cubitState = context.read<AudioBookCubit>().state;
    final sentenceIndex = cubitState.currentLineIndex;

    if (sentenceIndex == -1 ||
        cubitState.sentenceToParagraphMap.isEmpty ||
        !_scrollController.hasClients) {
      return;
    }

    final paragraphIndex = cubitState.sentenceToParagraphMap[sentenceIndex];
    if (paragraphIndex >= _paragraphKeys.length) return;

    final paragraphKey = _paragraphKeys[paragraphIndex];
    final paragraphContext = paragraphKey.currentContext;
    if (paragraphContext == null) return;

    final scrollRenderBox = context.findRenderObject() as RenderBox?;
    if (scrollRenderBox == null) return;

    final paragraphRenderBox = paragraphContext.findRenderObject() as RenderBox;
    final richText = paragraphContext.widget as RichText;
    final textSpan = richText.text as TextSpan;

    int charOffset = 0;
    for (int i = 0; i < sentenceIndex; i++) {
      if (cubitState.sentenceToParagraphMap.length > i &&
          cubitState.sentenceToParagraphMap[i] == paragraphIndex) {
        charOffset +=
            '${cubitState.transcript[i].text.replaceAll('\n', ' ').trim()} '
                .length;
      }
    }

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: paragraphRenderBox.size.width);

    final sentenceLocalOffset = textPainter.getOffsetForCaret(
      TextPosition(offset: charOffset),
      Rect.zero,
    );

    final sentenceGlobalOffset = paragraphRenderBox.localToGlobal(
      sentenceLocalOffset,
      ancestor: scrollRenderBox,
    );
    final viewportHeight = _scrollController.position.viewportDimension;
    final desiredYPosition = viewportHeight * 0.25;

    final targetScrollOffset =
        _scrollController.offset + sentenceGlobalOffset.dy - desiredYPosition;

    _scrollController.animateTo(
      targetScrollOffset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioBookCubit, AudioBookState>(
      listenWhen: (prev, curr) {
        if (prev.paragraphs.length != curr.paragraphs.length) {
          _paragraphKeys = List.generate(
            curr.paragraphs.length,
            (_) => GlobalKey(),
          );
        }
        return prev.currentLineIndex != curr.currentLineIndex;
      },
      listener: (context, state) {
        if (state.currentLineIndex != -1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToHighlightedSentence();
          });
        }
      },
      child: BlocBuilder<AudioBookCubit, AudioBookState>(
        builder: (context, state) {
          if (state.status == AudioPlayerStatus.loading &&
              state.paragraphs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.paragraphs.isEmpty) {
            return const Center(child: Text('No content available.'));
          }

          if (_paragraphKeys.length != state.paragraphs.length) {
            _paragraphKeys = List.generate(
              state.paragraphs.length,
              (_) => GlobalKey(),
            );
          }

          final List<Widget> paragraphWidgets = [];
          for (
            int paragraphIndex = 0;
            paragraphIndex < state.paragraphs.length;
            paragraphIndex++
          ) {
            final paragraphText = state.paragraphs[paragraphIndex];

            if (paragraphText.trim().isEmpty) {
              paragraphWidgets.add(const SizedBox(height: 40.0));
              continue;
            }

            final List<TextSpan> spans = [];
            final currentSentenceIndex = state.currentLineIndex;
            final activeParagraphIndex =
                currentSentenceIndex == -1
                    ? -1
                    : state.sentenceToParagraphMap[currentSentenceIndex];
            final bool isParagraphActive =
                paragraphIndex == activeParagraphIndex;

            for (int i = 0; i < state.transcript.length; i++) {
              if (state.sentenceToParagraphMap.length > i &&
                  state.sentenceToParagraphMap[i] == paragraphIndex) {
                final sentence = state.transcript[i];
                final isSentenceHighlighted = i == currentSentenceIndex;

                Color textColor;
                if (isSentenceHighlighted) {
                  textColor = const Color(0xFF009AFF);
                } else {
                  textColor =
                      isParagraphActive
                          ? const Color(0xFF182230)
                          : const Color(0xFF182230).withValues(alpha: 0.12);
                }

                spans.add(
                  TextSpan(
                    text: '${sentence.text.replaceAll('\n', ' ').trim()} ',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                    ),
                  ),
                );
              }
            }

            if (spans.isNotEmpty) {
              paragraphWidgets.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: GestureDetector(
                    onTapDown: (details) {
                      final paragraphContext =
                          _paragraphKeys[paragraphIndex].currentContext;
                      if (paragraphContext == null) return;
                      final box =
                          paragraphContext.findRenderObject() as RenderBox;
                      final localOffset = box.globalToLocal(
                        details.globalPosition,
                      );

                      final richText = paragraphContext.widget as RichText;
                      final textSpan = richText.text as TextSpan;

                      final textPainter = TextPainter(
                        text: textSpan,
                        textDirection: TextDirection.ltr,
                      )..layout(minWidth: 0, maxWidth: box.size.width);

                      final position = textPainter.getPositionForOffset(
                        localOffset,
                      );
                      int charIndex = position.offset;

                      int cumulativeCharCount = 0;
                      for (int i = 0; i < state.transcript.length; i++) {
                        if (state.sentenceToParagraphMap[i] == paragraphIndex) {
                          final sentence = state.transcript[i];
                          final sentenceText =
                              '${sentence.text.replaceAll('\n', ' ').trim()} ';
                          cumulativeCharCount += sentenceText.length;

                          if (charIndex < cumulativeCharCount) {
                            final seekPosition = Duration(
                              milliseconds: sentence.startTime.round(),
                            );
                            context.read<AudioBookCubit>().seek(seekPosition);
                            return;
                          }
                        }
                      }
                    },
                    child: RichText(
                      key:
                          _paragraphKeys.length > paragraphIndex
                              ? _paragraphKeys[paragraphIndex]
                              : null,
                      text: TextSpan(children: spans),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              );
            } else {
              paragraphWidgets.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    state.paragraphs[paragraphIndex].replaceAll('*', ''),
                    style: const TextStyle(
                      color: Color(0xFF182230),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              );
            }
          }

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: paragraphWidgets,
            ),
          );
        },
      ),
    );
  }
}
