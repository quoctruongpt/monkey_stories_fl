import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart'; // Import Auth Cubit
// import 'package:monkey_stories/blocs/auth/auth_state.dart'; // Remove this import
import 'package:monkey_stories/blocs/login/login_state.dart'; // Import Login State
import 'package:monkey_stories/models/password.dart';
import 'dart:async';

import 'package:monkey_stories/models/username.dart'; // Import dart:async để sử dụng StreamSubscription

final logger = Logger('LoginCubit');

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit _authenticationCubit;
  late StreamSubscription _authSubscription;

  LoginCubit(this._authenticationCubit) : super(const LoginState()) {
    // Lắng nghe sự thay đổi trạng thái của AuthenticationCubit
    _authSubscription = _authenticationCubit.stream.listen((authState) {
      if (authState is AuthenticationFailure) {
        // Nếu Auth thất bại (ví dụ: sai pass), cập nhật LoginState
        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage: authState.message, // Lấy lỗi từ AuthState
            clearErrorMessage: false,
          ),
        );
      } else if (authState is AuthenticationLoading) {
        // Nếu Auth đang loading (do LoginCubit gọi), LoginCubit cũng loading
        // Tránh trường hợp này nếu việc loading được quản lý bởi AuthCubit từ nguồn khác
        // Cân nhắc chỉ đặt loading khi loginSubmitted được gọi
        // emit(state.copyWith(status: FormSubmissionStatus.loading));
      } else if (authState is AuthenticationAuthenticated) {
        // Nếu Auth thành công, Login cũng thành công
        emit(state.copyWith(status: FormSubmissionStatus.success));
      } else if (authState is AuthenticationUnauthenticated &&
          state.status == FormSubmissionStatus.loading) {
        // Nếu quay về Unauthenticated trong khi Login đang loading (có thể do lỗi mạng trong AuthCubit)
        // Cập nhật trạng thái failure cho Login form
        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage: 'Đã xảy ra lỗi không xác định.',
            clearErrorMessage: false,
          ),
        );
      }
    });
  }

  void usernameChanged(String value) {
    final username = Username.dirty(value);
    // Cập nhật username và xóa lỗi cũ (nếu có) khi người dùng nhập liệu
    final isValid = Formz.validate([username, state.password]);
    emit(
      state.copyWith(
        username: username,
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
        isValidForm: isValid,
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    // Cập nhật password và xóa lỗi cũ (nếu có) khi người dùng nhập liệu
    final isValid = Formz.validate([state.username, password]);
    emit(
      state.copyWith(
        password: password,
        status: FormSubmissionStatus.initial,
        clearErrorMessage: true,
        isValidForm: isValid,
      ),
    );
  }

  Future<void> loginSubmitted() async {
    logger.info('loginSubmitted: ${state.username} ${state.password}');
    // Đặt trạng thái về initial để xóa các lỗi cũ từ server

    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );
    try {
      // Gọi hàm login của AuthenticationCubit
      await _authenticationCubit.logIn(
        username: state.username.value,
        password: state.password.value,
      );
      // Kết quả thành công/thất bại sẽ được xử lý bởi StreamSubscription ở trên
    } catch (e) {
      // Bắt lỗi trực tiếp từ việc gọi _authenticationCubit.logIn (ít xảy ra nếu AuthCubit bắt lỗi tốt)
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessage: e.toString(),
          clearErrorMessage: false,
        ),
      );
    }
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible!));
  }

  // Đừng quên hủy subscription khi Cubit bị đóng
  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
