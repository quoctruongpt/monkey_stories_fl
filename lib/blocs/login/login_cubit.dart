import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart'; // Import Auth Cubit
import 'package:monkey_stories/blocs/login/login_state.dart'; // Import Login State
import 'package:monkey_stories/core/constants/auth.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/utils/validate/password.dart';
import 'dart:async';

import 'package:monkey_stories/utils/validate/username.dart'; // Import dart:async để sử dụng StreamSubscription
import 'package:monkey_stories/repositories/auth_repository.dart';
import 'package:monkey_stories/models/auth/login_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final logger = Logger('LoginCubit');

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit _authenticationCubit;
  final AuthRepository _authRepository;
  final String? initialUsername;

  LoginCubit(
    this._authenticationCubit,
    this._authRepository,
    this.initialUsername,
  ) : super(LoginState(username: Username.dirty(initialUsername ?? '')));

  void loadLastLogin() async {
    try {
      final lastLogin = await _authRepository.getLastLogin();

      if (lastLogin == null) {
        return;
      }

      String? name;
      switch (lastLogin.loginType) {
        case LoginType.phone:
          if (initialUsername == null) {
            usernameChanged(lastLogin.phone ?? '');
          }
          break;
        case LoginType.email:
          final userGoogle = await _authRepository.getUserGoogle();
          if (userGoogle != null) {
            name = userGoogle.displayName;
          } else if (lastLogin.email != null) {
            usernameChanged(lastLogin.email ?? '');
          }
          break;
        case LoginType.facebook:
          final userFacebook = await _authRepository.getUserFacebook();
          if (userFacebook != null) {
            name = userFacebook['name'];
          }
          break;
        case LoginType.apple:
          if (lastLogin.appleId != null) {
            final credentialState = await _authRepository
                .getCredentialStateApple(lastLogin.appleId ?? '');
            if (credentialState == CredentialState.authorized) {
              name = lastLogin.name;
            }
          }
        default:
          return;
      }

      if (name != null) {
        emit(
          state.copyWith(
            lastLogin: LastLoginInfo(
              name: name,
              loginType: lastLogin.loginType,
              token: lastLogin.token,
              appleId: lastLogin.appleId,
              email: lastLogin.email,
            ),
          ),
        );
      }
    } catch (e) {
      logger.severe('loadLastLogin error: ${e}');
    }
  }

  void loginWithLastLogin() async {
    final lastLogin = state.lastLogin;
    final LoginType? loginType = lastLogin?.loginType;
    if (lastLogin != null && loginType != null) {
      emit(state.copyWith(status: FormSubmissionStatus.loading));
      try {
        LoginResponseData? response;
        switch (lastLogin.loginType) {
          case LoginType.email:
            final userGoogle = await _authRepository.getUserGoogle();
            final auth = await userGoogle?.authentication;
            final token = auth?.accessToken;
            final email = userGoogle?.email ?? '';
            response = await _authRepository.loginWithLastLogin(
              loginType,
              email,
              token ?? '',
              '',
              '',
            );
            break;
          case LoginType.facebook:
            final userFacebook = await _authRepository.getUserFacebook();
            final token = await _authRepository.getOldFacebookToken();
            final email = userFacebook?['email'];
            response = await _authRepository.loginWithLastLogin(
              loginType,
              email ?? '',
              token?.tokenString ?? '',
              '',
              '',
            );
            break;
          case LoginType.apple:
            response = await _authRepository.loginWithLastLogin(
              loginType,
              lastLogin.email ?? '',
              lastLogin.token ?? '',
              lastLogin.name ?? '',
              lastLogin.appleId ?? '',
            );
            break;
          default:
            break;
        }

        if (response != null) {
          emit(state.copyWith(status: FormSubmissionStatus.success));
        } else {
          emit(state.copyWith(status: FormSubmissionStatus.failure));
        }
      } catch (e) {
        emit(state.copyWith(status: FormSubmissionStatus.failure));
      }
    }
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

  void loginWithGoogle() async {
    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );
    try {
      final response = await _authRepository.loginWithGoogle();
      if (response != null) {
        emit(state.copyWith(status: FormSubmissionStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessageDialog: 'login.popup_error.google',
        ),
      );
    }
  }

  void loginWithApple() async {
    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _authRepository.loginWithApple();
      if (response != null) {
        emit(state.copyWith(status: FormSubmissionStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessageDialog: 'login.popup_error.apple',
        ),
      );
    }
  }

  void loginWithFacebook() async {
    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await _authRepository.loginWithFacebook();
      if (response != null) {
        emit(state.copyWith(status: FormSubmissionStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessageDialog: 'login.popup_error.facebook',
        ),
      );
    }
  }

  void clearErrorDialog() {
    emit(state.copyWith(errorMessageDialog: null));
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
