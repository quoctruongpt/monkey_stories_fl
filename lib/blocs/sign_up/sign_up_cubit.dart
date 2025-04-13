import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/auth/auth_cubit.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/models/auth/login_data.dart';
import 'package:monkey_stories/models/auth/sign_up_data.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/repositories/auth_repository.dart';
part 'sign_up_state.dart';

final logger = Logger('SignUpCubit');

enum StepSignUp { phone, password }

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;
  final AuthenticationCubit _authenticationCubit;
  Timer? _debounce;
  CancelToken? _cancelCheckPhoneNumberToken;

  SignUpCubit(this._authRepository, this._authenticationCubit)
    : super(const SignUpState(step: StepSignUp.phone, isShowPassword: false));

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
        phoneErrorMessage: null,
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
        final response = await _authRepository.checkPhoneNumber(
          phone.value,
          _cancelCheckPhoneNumberToken,
        );
        if (response.status == ApiStatus.success) {
          emit(state.copyWith(isPhoneValid: true));
        } else {
          emit(
            state.copyWith(
              isPhoneValid: false,
              phoneErrorMessage: response.message,
              phoneErrorCode: response.code,
            ),
          );
        }
      } finally {
        emit(state.copyWith(isCheckingPhone: false));
      }
    });
  }

  Future<void> signUpPressed() async {
    emit(state.copyWith(isSignUpLoading: true, clearPhoneErrorMessage: true));
    try {
      final response = await _authRepository.signUp(
        SignUpRequestData(
          type: LoginType.phone,
          countryCode: state.phone.value.countryCode,
          phone: state.phone.value.phoneNumber,
          password: state.password.value,
        ),
      );

      if (response != null) {
        await _getInfoUser();
        emit(state.copyWith(isSignUpSuccess: true));
      }
    } catch (e) {
      if (e is ApiResponse) {
        emit(state.copyWith(signUpErrorMessage: e.message));
        return;
      }
      emit(state.copyWith(signUpErrorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isSignUpLoading: false));
    }
  }

  void signUpWithGoogle() async {
    emit(state.copyWith(isSignUpLoading: true, clearPhoneErrorMessage: true));
    try {
      final response = await _authRepository.loginWithGoogle();
      if (response != null) {
        await _getInfoUser();
        emit(state.copyWith(isSignUpSuccess: true));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSignUpSuccess: false,
          popupErrorMessage: 'login.popup_error.google',
        ),
      );
    } finally {
      emit(state.copyWith(isSignUpLoading: false));
    }
  }

  void signUpWithFacebook() async {
    emit(state.copyWith(isSignUpLoading: true, clearPhoneErrorMessage: true));
    try {
      final response = await _authRepository.loginWithFacebook();
      if (response != null) {
        await _getInfoUser();
        emit(state.copyWith(isSignUpSuccess: true));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSignUpSuccess: false,
          popupErrorMessage: 'login.popup_error.facebook',
        ),
      );
    } finally {
      emit(state.copyWith(isSignUpLoading: false));
    }
  }

  void signUpWithApple() async {
    emit(state.copyWith(isSignUpLoading: true, clearPhoneErrorMessage: true));
    try {
      final response = await _authRepository.loginWithApple();
      if (response != null) {
        await _getInfoUser();
        emit(state.copyWith(isSignUpSuccess: true));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSignUpSuccess: false,
          popupErrorMessage: 'login.popup_error.apple',
        ),
      );
    } finally {
      emit(state.copyWith(isSignUpLoading: false));
    }
  }

  Future<void> _getInfoUser() async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      _authenticationCubit.saveUser(user);
    } else {
      throw Exception('Không thể lấy thông tin người dùng');
    }
  }

  void toggleShowPassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
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
