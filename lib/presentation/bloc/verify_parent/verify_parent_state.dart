part of 'verify_parent_cubit.dart';

class VerifyParentState extends Equatable {
  const VerifyParentState({
    this.randomNumbers = const [],
    this.currentIndex = 0,
    this.input = '',
    this.isCorrect = false,
  });

  final List<int> randomNumbers;
  final int currentIndex;
  final String input;
  final bool isCorrect;

  VerifyParentState copyWith({
    List<int>? randomNumbers,
    int? currentIndex,
    String? input,
    bool? isCorrect,
  }) {
    return VerifyParentState(
      randomNumbers: randomNumbers ?? this.randomNumbers,
      currentIndex: currentIndex ?? this.currentIndex,
      input: input ?? this.input,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [randomNumbers, currentIndex, input, isCorrect];
}
