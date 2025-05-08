import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

// Đã xác thực
class SplashAuthenticated extends SplashState {}

// Đã tạo hồ sơ học thử nhưng cần tạo tài khoản
class SplashNeedCreateAccount extends SplashState {}

// Chưa xác thực và chưa từng đăng nhập
class SplashUnauthenticated extends SplashState {}

// Chưa xác thực và đã từng đăng nhập
class SplashAuthenticatedBefore extends SplashState {}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object> get props => [message];
}
