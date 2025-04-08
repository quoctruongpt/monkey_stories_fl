import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  // Khởi tạo với trạng thái ban đầu
  AuthenticationCubit() : super(AuthenticationInitial());

  // TODO: Implement repository/service injection

  // --- Các phương thức xử lý logic ---

  // Hàm kiểm tra trạng thái đăng nhập khi khởi động app (ví dụ)
  Future<void> checkAuthenticationStatus() async {
    emit(AuthenticationLoading());
    try {
      // TODO: Gọi service/repository để kiểm tra token/session
      // Giả sử đã đăng nhập
      await Future.delayed(const Duration(seconds: 1)); // Giả lập delay
      // emit(AuthenticationAuthenticated(/* user */));
      // Hoặc nếu chưa đăng nhập
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationFailure('Lỗi kiểm tra đăng nhập: ${e.toString()}'));
      // Có thể emit Unauthenticated ở đây nếu muốn
      // emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    emit(AuthenticationLoading());
    try {
      // TODO: Gọi service/repository để đăng nhập
      print('Logging in with: $username, $password'); // Placeholder
      await Future.delayed(const Duration(seconds: 2)); // Giả lập gọi API

      // --- Logic xử lý kết quả ---
      // Ví dụ: Nếu thành công
      // final user = ... // Lấy thông tin user từ response
      emit(AuthenticationAuthenticated(/* user */));

      // Ví dụ: Nếu thất bại (sai thông tin)
      // emit(AuthenticationFailure('Tên đăng nhập hoặc mật khẩu không đúng.'));
      // emit(AuthenticationUnauthenticated()); // Quay lại trạng thái chưa đăng nhập
    } catch (e) {
      emit(AuthenticationFailure('Lỗi đăng nhập: ${e.toString()}'));
      emit(
        AuthenticationUnauthenticated(),
      ); // Quay lại trạng thái chưa đăng nhập sau lỗi
    }
  }

  Future<void> signUp(/* Tham số cần thiết cho đăng ký */) async {
    emit(AuthenticationLoading());
    try {
      // TODO: Gọi service/repository để đăng ký
      await Future.delayed(const Duration(seconds: 2)); // Giả lập gọi API
      // emit(AuthenticationAuthenticated(/* user */)); // Có thể tự động đăng nhập sau khi đăng ký thành công
      // Hoặc chỉ chuyển về trạng thái chưa đăng nhập để yêu cầu login lại
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationFailure('Lỗi đăng ký: ${e.toString()}'));
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    emit(
      AuthenticationLoading(),
    ); // Hoặc có thể dùng state riêng cho reset password nếu cần
    try {
      // TODO: Gọi service/repository để yêu cầu reset mật khẩu
      print('Requesting password reset for: $email'); // Placeholder
      await Future.delayed(const Duration(seconds: 2));
      // Có thể emit một state thành công riêng hoặc quay về Unauthenticated
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(
        AuthenticationFailure('Lỗi yêu cầu reset mật khẩu: ${e.toString()}'),
      );
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> logOut() async {
    emit(AuthenticationLoading());
    try {
      // TODO: Gọi service/repository để đăng xuất (xóa token, session,...)
      print('Logging out...'); // Placeholder
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationFailure('Lỗi đăng xuất: ${e.toString()}'));
      // Vẫn nên emit Unauthenticated dù có lỗi
      emit(AuthenticationUnauthenticated());
    }
  }
}
