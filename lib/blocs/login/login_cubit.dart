import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart'; // Import Auth Cubit
// import 'package:monkey_stories/blocs/auth/auth_state.dart'; // Remove this import
import 'package:monkey_stories/blocs/login/login_state.dart'; // Import Login State
import 'package:monkey_stories/models/validate/password.dart';
import 'dart:async';

import 'package:monkey_stories/models/validate/username.dart'; // Import dart:async để sử dụng StreamSubscription

final logger = Logger('LoginCubit');

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit _authenticationCubit;
  late StreamSubscription<AuthState>
  _authSubscription; // Explicitly type the subscription

  LoginCubit(this._authenticationCubit) : super(const LoginState()) {
    // Lắng nghe sự thay đổi trạng thái của AuthenticationCubit
    _authSubscription = _authenticationCubit.stream.listen((authState) {
      logger.info('authState: ${authState.error != null}');
      // Kiểm tra lỗi trước
      if (authState.error != null) {
        // Nếu có lỗi trong AuthState, cập nhật LoginState
        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage:
                authState.error!.message, // Lấy lỗi từ AuthState.error
            clearErrorMessage: false,
          ),
        );
      } else if (authState.isAuthenticated) {
        // Nếu Auth thành công (isAuthenticated = true và không có lỗi)
        // Cần xóa cả lỗi cũ nếu có
        emit(
          state.copyWith(
            status: FormSubmissionStatus.success,
            clearErrorMessage: true, // Explicitly clear error on success
          ),
        );
      }
      // Không cần xử lý loading riêng ở đây vì LoginCubit tự quản lý loading state
      // Không cần xử lý Unauthenticated riêng vì trạng thái failure đã bao gồm trường hợp này nếu có lỗi
    });
  }

  void usernameChanged(String value) {
    logger.info('usernameChanged: $value');
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
      await _authenticationCubit.logInWithPhone(
        phone: state.username.value,
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
