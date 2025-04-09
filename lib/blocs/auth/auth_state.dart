part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final User? user;
  final AuthError? error;
  final bool isAuthenticated;

  const AuthState({this.user, this.error, this.isAuthenticated = false});

  AuthState copyWith({User? user, AuthError? error, bool? isAuthenticated}) {
    return AuthState(
      user: user ?? this.user,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [user, error];
}

class AuthError {
  final String message;
  final int code;

  const AuthError({required this.message, required this.code});
}
