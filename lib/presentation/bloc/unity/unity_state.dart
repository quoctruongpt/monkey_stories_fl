part of 'unity_cubit.dart';

class UnityState extends Equatable {
  final bool isUnityVisible;
  final bool isUnityLoading;

  const UnityState({required this.isUnityVisible, this.isUnityLoading = false});

  UnityState copyWith({bool? isUnityVisible, bool? isUnityLoading}) {
    return UnityState(
      isUnityVisible: isUnityVisible ?? this.isUnityVisible,
      isUnityLoading: isUnityLoading ?? this.isUnityLoading,
    );
  }

  @override
  List<Object?> get props => [isUnityVisible, isUnityLoading];
}
