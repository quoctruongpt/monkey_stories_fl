part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final User? user;

  const AuthState({this.user});

  AuthState copyWith({User? user}) {
    return AuthState(user: user);
  }

  @override
  List<Object?> get props => [user];
}

class AuthError {
  final String message;
  final int code;

  const AuthError({required this.message, required this.code});
}
