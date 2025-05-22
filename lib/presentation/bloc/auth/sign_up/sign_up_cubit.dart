import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/usecases/auth/check_phone_number_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_usecase.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
part 'sign_up_state.dart';

final logger = Logger('SignUpCubit');

enum StepSignUp { phone, password }

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUsecase _signUpUsecase;
  final LoginUsecase _loginUsecase;
  final CheckPhoneNumberUsecase _checkPhoneNumberUsecase;
  final AppCubit _appCubit;

  final UserCubit _userCubit;

  Timer? _debounce;
  CancelToken? _cancelCheckPhoneNumberToken;

  SignUpCubit({
    required UserCubit userCubit,
    required SignUpUsecase signUpUsecase,
    required LoginUsecase loginUsecase,
    required CheckPhoneNumberUsecase checkPhoneNumberUsecase,
    required AppCubit appCubit,
  }) : _userCubit = userCubit,
       _signUpUsecase = signUpUsecase,
       _loginUsecase = loginUsecase,
       _checkPhoneNumberUsecase = checkPhoneNumberUsecase,
       _appCubit = appCubit,
       super(SignUpState(step: StepSignUp.phone));

  void countryCodeInit(String countryCode) {
    final phone = PhoneValidator.pure(countryCode: countryCode);
    emit(state.copyWith(phone: phone));
  }

  void countryCodeChanged(String countryCode) {
    final phone = PhoneValidator.dirty(
      PhoneNumberInput(
        countryCode: countryCode,
        phoneNumber: state.phone.value.phoneNumber,
      ),
    );

    if (countryCode != state.phone.value.countryCode) {
      checkPhoneNumber(phone);

      emit(
        state.copyWith(
          phone: phone,
          isPhoneValid: false,
          phoneErrorMessage: null,
        ),
      );
    }
  }

  void phoneChanged(String phoneNumber) {
    final phone = PhoneValidator.dirty(
      PhoneNumberInput(
        countryCode: state.phone.value.countryCode,
        phoneNumber: phoneNumber,
      ),
    );

    emit(
      state.copyWith(
        phone: phone,
        isPhoneValid: false,
        clearPhoneErrorMessage: true,
      ),
    );
    checkPhoneNumber(phone);
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(
      state.copyWith(
        password: password,
        isConfirmPasswordCorrect: _isConfirmPasswordCorrect(
          value,
          state.confirmPassword.value,
        ),
        clearPhoneErrorMessage: true,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = Password.dirty(value);

    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isConfirmPasswordCorrect: _isConfirmPasswordCorrect(
          state.password.value,
          value,
        ),
      ),
    );
  }

  bool _isConfirmPasswordCorrect(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  Future<void> checkPhoneNumber(PhoneValidator phone) async {
    if (!state.phone.isValid) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(
        state.copyWith(
          isCheckingPhone: true,
          isPhoneValid: false,
          clearPhoneErrorMessage: true,
        ),
      );
      try {
        _cancelCheckPhoneNumberToken?.cancel();
        final response = await _checkPhoneNumberUsecase.call(
          CheckPhoneNumberParams(
            countryCode: state.phone.value.countryCode,
            phoneNumber: state.phone.value.phoneNumber,
          ),
        );

        response.fold(
          (failure) {
            emit(
              state.copyWith(
                isPhoneValid: false,
                phoneErrorMessage: failure.message,
                phoneErrorCode: failure.code,
              ),
            );
          },
          (success) {
            emit(state.copyWith(isPhoneValid: true));
          },
        );
      } finally {
        emit(state.copyWith(isCheckingPhone: false));
      }
    });
  }

  Future<void> signUpPressed() async {
    emit(state.copyWith(isSignUpLoading: true, clearPhoneErrorMessage: true));
    try {
      final response = await _signUpUsecase.call(
        SignUpParams(
          countryCode: state.phone.value.countryCode,
          phoneNumber:
              state.phone.value.phoneNumber.startsWith('0')
                  ? state.phone.value.phoneNumber.substring(1)
                  : state.phone.value.phoneNumber,
          password: state.password.value,
          isUpgrade: _userCubit.state.user?.loginType == LoginType.skip,
        ),
      );

      response.fold(
        (failure) {
          emit(
            state.copyWith(
              signUpErrorMessage: failure.message,
              isSignUpLoading: false,
            ),
          );
        },
        (success) async {
          if (_userCubit.state.isPurchasing) {
            _userCubit.togglePurchasing();
          }
          _appCubit.changeLanguage(_appCubit.state.languageCode);
          await _userCubit.loadUpdate();
          emit(state.copyWith(isSignUpSuccess: true));
        },
      );
    } catch (e) {
      if (e is ApiResponse) {
        emit(state.copyWith(signUpErrorMessage: e.message));
      } else {
        emit(state.copyWith(signUpErrorMessage: e.toString()));
      }
      emit(state.copyWith(isSignUpLoading: false));
    }
  }

  Future<void> _signUpWithSocial(LoginParams params) async {
    try {
      emit(state.copyWith(isSignUpLoading: true, clearPhoneErrorMessage: true));
      final result = await _loginUsecase.call(params);
      result.fold(
        (failure) {
          throw failure;
        },
        (loginStatus) async {
          await _userCubit.loadUpdate();
          emit(state.copyWith(isSignUpSuccess: true, isSignUpLoading: false));
        },
      );
    } catch (e) {
      emit(state.copyWith(isSignUpLoading: false));
      switch (params.loginType) {
        case LoginType.facebook:
          emit(
            state.copyWith(
              isSignUpSuccess: false,
              popupErrorMessage: 'login.popup_error.facebook',
            ),
          );
          return;
        case LoginType.apple:
          emit(
            state.copyWith(
              isSignUpSuccess: false,
              popupErrorMessage: 'login.popup_error.apple',
            ),
          );
          return;
        case LoginType.email:
          if (params.email != null) {
            break;
          }
          emit(
            state.copyWith(
              isSignUpSuccess: false,
              popupErrorMessage: 'login.popup_error.google',
            ),
          );
          return;
        default:
          break;
      }

      emit(state.copyWith(popupErrorMessage: 'error'));
    }
  }

  void signUpWithGoogle() async {
    _signUpWithSocial(const LoginParams(loginType: LoginType.email));
  }

  void signUpWithFacebook() async {
    _signUpWithSocial(const LoginParams(loginType: LoginType.facebook));
  }

  void signUpWithApple() async {
    _signUpWithSocial(const LoginParams(loginType: LoginType.apple));
  }

  void toggleShowPassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  void toggleShowConfirmPassword() {
    emit(state.copyWith(isShowConfirmPassword: !state.isShowConfirmPassword));
  }

  void nextToPassword() {
    emit(state.copyWith(step: StepSignUp.password));
  }

  void backToPhone() {
    emit(state.copyWith(step: StepSignUp.phone));
  }

  void clearPopupErrorMessage() {
    emit(state.copyWith(popupErrorMessage: null));
  }
}
