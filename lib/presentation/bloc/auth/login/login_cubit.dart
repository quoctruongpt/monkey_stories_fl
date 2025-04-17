import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/auth/login_with_last_login_entity.dart';
import 'package:monkey_stories/domain/entities/auth/user_sosial_entity.dart';
import 'package:monkey_stories/domain/usecases/auth/get_last_login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/get_user_social_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_with_last_login_usecase.dart';
import 'package:monkey_stories/presentation/bloc/auth/login/login_state.dart'; // Import Login State
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'dart:async';

import 'package:monkey_stories/core/validators/username.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

final logger = Logger('LoginCubit');

class LoginCubit extends Cubit<LoginState> {
  final UserCubit _userCubit;
  final LoginUsecase _loginUsecase;
  final LoginWithLastLoginUsecase _loginWithLastLoginUsecase;
  final GetLastLoginUsecase _getLastLoginUsecase;
  final GetUserSocialUsecase _getUserSocialUsecase;

  UserSocialEntity? _lastLogin;

  LoginCubit({
    required UserCubit userCubit,
    required LoginUsecase loginUsecase,
    required LoginWithLastLoginUsecase loginWithLastLoginUsecase,
    required GetLastLoginUsecase getLastLoginUsecase,
    required GetUserSocialUsecase getUserSocialUsecase,
  }) : _userCubit = userCubit,
       _loginUsecase = loginUsecase,
       _loginWithLastLoginUsecase = loginWithLastLoginUsecase,
       _getLastLoginUsecase = getLastLoginUsecase,
       _getUserSocialUsecase = getUserSocialUsecase,
       super(const LoginState(username: Username.dirty('')));

  void loadLastLogin(String? initialUsername) async {
    try {
      if (initialUsername != null) {
        usernameChanged(initialUsername);
        return;
      }

      final lastLogin = await _getLastLoginUsecase.call(NoParams());
      lastLogin.fold(
        (failure) {
          return;
        },
        (lastLogin) async {
          if (lastLogin == null) {
            return;
          }

          String? name;
          {
            switch (lastLogin.loginType) {
              case LoginType.phone:
                if (initialUsername == null) {
                  usernameChanged(lastLogin.phone ?? '');
                }
                break;
              case LoginType.email:
              case LoginType.facebook:
              case LoginType.apple:
                if (!lastLogin.isSocial) {
                  usernameChanged(lastLogin.email ?? '');
                  break;
                }
                final userLastLogin = await _getUserSocialUsecase.call(
                  lastLogin.loginType,
                );

                userLastLogin.fold(
                  (failure) {
                    return;
                  },
                  (userLastLogin) {
                    name = userLastLogin?.name;
                    _lastLogin = userLastLogin;
                  },
                );
                break;

              default:
                return;
            }
          }

          if (name != null) {
            emit(
              state.copyWith(
                lastLogin: LastLoginInfo(
                  name: name,
                  loginType: lastLogin.loginType,
                  token: lastLogin.token,
                  appleUserCredential: lastLogin.appleUserCredential,
                  email: lastLogin.email,
                ),
              ),
            );
          }
        },
      );
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
        final result = await _loginWithLastLoginUsecase.call(
          LoginWithLastLoginEntity(
            loginType: lastLogin.loginType,
            email: _lastLogin?.email ?? '',
            token: _lastLogin?.token as String,
          ),
        );

        result.fold(
          (failure) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  status: FormSubmissionStatus.failure,
                  errorMessageDialog: 'Login failed',
                ),
              );
            }
          },
          (response) {
            emit(state.copyWith(status: FormSubmissionStatus.success));
          },
        );
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
        clearErrorMessage: true,
        isValidForm: isValid,
      ),
    );
  }

  Future<void> login(LoginParams params) async {
    final result = await _loginUsecase.call(params);
    result.fold(
      (failure) {
        if (failure.code == AuthConstants.pwErrorCode) {
          _incrementFailedAttempts();
        }

        switch (params.loginType) {
          case LoginType.facebook:
            emit(
              state.copyWith(
                status: FormSubmissionStatus.failure,
                errorMessageDialog: 'login.popup_error.facebook',
              ),
            );
            return;
          case LoginType.apple:
            emit(
              state.copyWith(
                status: FormSubmissionStatus.failure,
                errorMessageDialog: 'login.popup_error.apple',
              ),
            );
            return;
          case LoginType.email:
            if (params.email != null) {
              break;
            }
            emit(
              state.copyWith(
                status: FormSubmissionStatus.failure,
                errorMessageDialog: 'login.popup_error.google',
              ),
            );
            return;
          default:
            break;
        }

        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (loginStatus) async {
        await _userCubit.loadUpdate();
        emit(state.copyWith(status: FormSubmissionStatus.success));
      },
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

      await login(
        LoginParams(
          loginType: isEmail ? LoginType.email : LoginType.phone,
          phone: isEmail ? '' : username,
          email: isEmail ? username : '',
          password: password,
        ),
      );
    } catch (e) {
      logger.severe('loginSubmitted error: ${e}');

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
      await login(const LoginParams(loginType: LoginType.email));
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
      await login(const LoginParams(loginType: LoginType.apple));
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
      await login(const LoginParams(loginType: LoginType.facebook));
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
