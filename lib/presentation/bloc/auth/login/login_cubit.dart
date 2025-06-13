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
import 'package:monkey_stories/domain/usecases/purchased/restore_purchased_usecase.dart';
import 'package:monkey_stories/domain/usecases/tracking/sign_in/ms_sign_in.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/auth/login/login_state.dart'; // Import Login State
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'dart:async';

import 'package:monkey_stories/core/validators/username.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/domain/usecases/active_license/verify_cod_usercrm.dart';

final logger = Logger('LoginCubit');

class LoginTrackingData {
  String type = '';
  String username = '';
  String phone = '';
  String email = '';
  bool isSuccess = false;
  bool forgotPassword = false;
  String? errorMessage;
  bool haveClickedSignUp = false;
  bool haveClickedActiveCode = false;
}

class LoginCubit extends Cubit<LoginState> {
  final UserCubit _userCubit;
  final LoginUsecase _loginUsecase;
  final LoginWithLastLoginUsecase _loginWithLastLoginUsecase;
  final GetLastLoginUsecase _getLastLoginUsecase;
  final GetUserSocialUsecase _getUserSocialUsecase;
  final RestorePurchasedUsecase _restorePurchasedUsecase;
  final VerifyCodUserCrmUseCase _verifyCodUserCrmUsecase;
  final MsSignInTrackingUsecase _msSignInTrackingUsecase;

  final ProfileCubit _profileCubit;

  UserSocialEntity? _lastLogin;
  final _trackingData = LoginTrackingData();

  LoginCubit({
    required UserCubit userCubit,
    required LoginUsecase loginUsecase,
    required LoginWithLastLoginUsecase loginWithLastLoginUsecase,
    required GetLastLoginUsecase getLastLoginUsecase,
    required GetUserSocialUsecase getUserSocialUsecase,
    required RestorePurchasedUsecase restorePurchasedUsecase,
    required ProfileCubit profileCubit,
    required VerifyCodUserCrmUseCase verifyCodUserCrmUsecase,
    required MsSignInTrackingUsecase msSignInTrackingUsecase,
  }) : _userCubit = userCubit,
       _loginUsecase = loginUsecase,
       _loginWithLastLoginUsecase = loginWithLastLoginUsecase,
       _getLastLoginUsecase = getLastLoginUsecase,
       _getUserSocialUsecase = getUserSocialUsecase,
       _restorePurchasedUsecase = restorePurchasedUsecase,
       _profileCubit = profileCubit,
       _verifyCodUserCrmUsecase = verifyCodUserCrmUsecase,
       _msSignInTrackingUsecase = msSignInTrackingUsecase,
       super(const LoginState());

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
      logger.severe('loadLastLogin error: $e');
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
              _trackingData.errorMessage = failure.message;
              emit(
                state.copyWith(
                  status: FormSubmissionStatus.failure,
                  errorMessageDialog: 'Login failed',
                ),
              );
            }
          },
          (response) {
            loginSuccess();
          },
        );
      } catch (e) {
        _trackingData.errorMessage = e.toString();
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
            _trackingData.errorMessage = 'login.popup_error.facebook';
            emit(
              state.copyWith(
                status: FormSubmissionStatus.failure,
                errorMessageDialog: 'login.popup_error.facebook',
              ),
            );
            return;
          case LoginType.apple:
            _trackingData.errorMessage = 'login.popup_error.apple';
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
            _trackingData.errorMessage = 'login.popup_error.google';
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

        _trackingData.errorMessage = failure.message;
        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (loginStatus) async {
        await loginSuccess();
      },
    );
  }

  Future<void> loginSuccess() async {
    await _restorePurchasedUsecase.call(NoParams());
    if (_userCubit.state.isPurchasing) {
      _userCubit.togglePurchasing();
    }
    await _userCubit.loadUpdate();
    await _profileCubit.getListProfile();
    emit(state.copyWith(status: FormSubmissionStatus.success));
  }

  Future<void> loginSubmitted() async {
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

      final loginType = getLoginType(username);

      if (loginType == LoginType.userCrm) {
        _trackingData.type = 'username';
        _trackingData.username = username;
        await loginWithUserCrm(username, password);
        return;
      }

      if (loginType == LoginType.email) {
        _trackingData.type = 'email';
        _trackingData.email = username;
      }

      _trackingData.type = 'phone';
      _trackingData.phone = username;

      await login(
        LoginParams(
          loginType: loginType,
          phone: loginType == LoginType.phone ? username : '',
          email: loginType == LoginType.email ? username : '',
          password: password,
        ),
      );
    } catch (e) {
      logger.severe('loginSubmitted error: $e');
      _trackingData.errorMessage = e.toString();

      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  LoginType getLoginType(String username) {
    LoginType loginType;
    final isEmail = username.contains('@');
    final isPhone = RegExp(
      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
    ).hasMatch(username);

    if (isEmail) {
      loginType = LoginType.email;
    } else if (isPhone) {
      loginType = LoginType.phone;
    } else {
      loginType = LoginType.userCrm;
    }

    return loginType;
  }

  Future<void> loginWithUserCrm(String username, String password) async {
    final result = await _verifyCodUserCrmUsecase.call(
      VerifyCodUserCrmParams(username: username, password: password),
    );

    result.fold(
      (failure) {
        _trackingData.errorMessage = failure.message;
        emit(
          state.copyWith(
            status: FormSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: FormSubmissionStatus.success,
            licenseCodeInfo: response,
          ),
        );
      },
    );
  }

  void loginWithGoogle() async {
    _trackingData.type = 'gg';

    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );
    try {
      await login(const LoginParams(loginType: LoginType.email));
    } catch (e) {
      _trackingData.errorMessage = e.toString();
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessageDialog: 'login.popup_error.google',
        ),
      );
    }
  }

  void loginWithApple() async {
    _trackingData.type = 'apple';

    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      await login(const LoginParams(loginType: LoginType.apple));
    } catch (e) {
      _trackingData.errorMessage = e.toString();
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessageDialog: 'login.popup_error.apple',
        ),
      );
    }
  }

  void loginWithFacebook() async {
    _trackingData.type = 'fb';

    emit(
      state.copyWith(
        status: FormSubmissionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      await login(const LoginParams(loginType: LoginType.facebook));
    } catch (e) {
      _trackingData.errorMessage = e.toString();
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

  void forgotPasswordClicked() {
    _trackingData.forgotPassword = true;
  }

  void signUpClicked() {
    _trackingData.haveClickedSignUp = true;
  }

  void activeCodeClicked() {
    _trackingData.haveClickedActiveCode = true;
  }

  void signInTracking() {
    final params = MsSignInTrackingParams(
      type: _trackingData.type,
      username: _trackingData.username,
      phone: _trackingData.phone,
      email: _trackingData.email,
      isSuccess: state.status == FormSubmissionStatus.success,
      forgotPassword: _trackingData.forgotPassword,
      haveClickedSignUp: _trackingData.haveClickedSignUp,
      haveClickedActiveCode: _trackingData.haveClickedActiveCode,
      errorMessage: _trackingData.errorMessage,
      haveOccurredError: _trackingData.errorMessage != null,
    );
    _msSignInTrackingUsecase.call(params);
  }

  // Đừng quên hủy subscription khi Cubit bị đóng
}
