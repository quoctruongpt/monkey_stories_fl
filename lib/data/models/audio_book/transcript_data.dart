import 'package:equatable/equatable.dart';

class WordData extends Equatable {
  final String text;
  final double startTime;
  final double endTime;

  const WordData({
    required this.text,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [text, startTime, endTime];
}

class LineData extends Equatable {
  final String line;
  final List<WordData> words;

  const LineData({required this.line, required this.words});

  @override
  List<Object?> get props => [line, words];
}
