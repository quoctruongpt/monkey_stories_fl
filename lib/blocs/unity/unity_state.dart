part of 'unity_cubit.dart';

class UnityState {
  final bool isUnityVisible;

  UnityState({required this.isUnityVisible});

  UnityState copyWith({bool? isUnityVisible}) {
    return UnityState(isUnityVisible: isUnityVisible ?? this.isUnityVisible);
  }
}
