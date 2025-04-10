import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart'; // Import Auth Cubit
import 'package:monkey_stories/blocs/login/login_state.dart'; // Import Login State
import 'package:monkey_stories/core/constants/auth.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/models/auth/login_data.dart';
import 'package:monkey_stories/models/validate/password.dart';
import 'dart:async';

import 'package:monkey_stories/models/validate/username.dart'; // Import dart:async để sử dụng StreamSubscription
import 'package:monkey_stories/repositories/auth_repository.dart';

final logger = Logger('LoginCubit');

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit _authenticationCubit;
  final AuthRepository _authRepository;

  LoginCubit(this._authenticationCubit, this._authRepository)
    : super(const LoginState());

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

    if (!state.isValidForm) {
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessage: 'Vui lòng nhập đúng tên đăng nhập và mật khẩu',
          clearErrorMessage: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      // Xác định loại đăng nhập (email hoặc số điện thoại)
      final username = state.username.value;
      final password = state.password.value;
      final isEmail = username.contains('@');

      final loginData =
          isEmail
              ? await _authRepository.loginWithEmail(username, password)
              : await _authRepository.loginWithPhone(username, password);

      if (loginData != null) {
        // Lấy thông tin user từ API
        final user = await _authRepository.getCurrentUser();

        if (user != null) {
          // Lưu thông tin user vào AuthCubit
          _authenticationCubit.saveUser(user);
          emit(state.copyWith(status: FormSubmissionStatus.success));
        } else {
          emit(
            state.copyWith(
              status: FormSubmissionStatus.failure,
              errorMessage: 'Không thể lấy thông tin người dùng',
              clearErrorMessage: false,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage:
                'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập',
            clearErrorMessage: false,
          ),
        );
      }
    } catch (e) {
      logger.severe('loginSubmitted error: ${e}');
      if (e is ApiResponse) {
        if (e.code == AuthConstants.pwErrorCode) {
          _incrementFailedAttempts();
        }
        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage: e.message,
            clearErrorMessage: false,
          ),
        );
        return;
      }

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
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _incrementFailedAttempts() {
    emit(state.copyWith(failedAttempts: state.failedAttempts + 1));
  }

  void resetFailedAttempts() {
    emit(state.copyWith(failedAttempts: 0));
  }

  // Đừng quên hủy subscription khi Cubit bị đóng
  @override
  Future<void> close() {
    return super.close();
  }
}
