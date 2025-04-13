part of 'unity_cubit.dart';

class UnityState extends Equatable {
  final bool isUnityVisible;

  const UnityState({required this.isUnityVisible});

  UnityState copyWith({bool? isUnityVisible}) {
    return UnityState(isUnityVisible: isUnityVisible ?? this.isUnityVisible);
  }

  @override
  List<Object?> get props => [isUnityVisible];
}
