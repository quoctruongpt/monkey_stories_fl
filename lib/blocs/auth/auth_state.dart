part of 'auth_cubit.dart';

// Lớp cơ sở cho các trạng thái Authentication
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

// Trạng thái khởi tạo
class AuthenticationInitial extends AuthenticationState {}

// Trạng thái đang tải (ví dụ: đang gọi API)
class AuthenticationLoading extends AuthenticationState {}

// Trạng thái đã xác thực thành công
class AuthenticationAuthenticated extends AuthenticationState {
  // TODO: Thêm thuộc tính người dùng (user object)
  // final User user;
  // const AuthenticationAuthenticated(this.user);
  // @override
  // List<Object?> get props => [user];
}

// Trạng thái chưa xác thực (chưa đăng nhập hoặc đã đăng xuất)
class AuthenticationUnauthenticated extends AuthenticationState {}

// Trạng thái xác thực thất bại
class AuthenticationFailure extends AuthenticationState {
  final String message;

  const AuthenticationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
