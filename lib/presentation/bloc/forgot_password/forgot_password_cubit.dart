import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/validators/confirm_password.dart';
import 'package:monkey_stories/core/validators/email.dart';
import 'package:monkey_stories/core/validators/otp.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/usecases/auth/change_password_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/send_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/verify_otp_usecase.dart';

part 'forgot_password_state.dart';

final logger = Logger('ForgotPasswordCubit');

const otpResendTime = 60;
const otpWrongCount = 5;
const otpBlockTime = 300000;

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final VerifyOtpUsecase _verifyOtpUsecase;
  final SendOtpUsecase _sendOtpUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;

  Timer? _otpResendTimer;
  String _tokenChangePassword = '';
  ForgotPasswordCubit({
    required VerifyOtpUsecase verifyOtpUsecase,
    required SendOtpUsecase sendOtpUsecase,
    required ChangePasswordUsecase changePasswordUsecase,
  }) : _verifyOtpUsecase = verifyOtpUsecase,
       _sendOtpUsecase = sendOtpUsecase,
       _changePasswordUsecase = changePasswordUsecase,
       super(ForgotPasswordState());

  void chooseMethod(ForgotPasswordType method) {
    emit(state.copyWith(method: method));
  }

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

    emit(state.copyWith(phone: phone, clearPhoneErrorOther: true));
  }

  void phoneChanged(String phoneNumber) {
    final phone = PhoneValidator.dirty(
      PhoneNumberInput(
        countryCode: state.phone.value.countryCode,
        phoneNumber: phoneNumber,
      ),
    );

    emit(state.copyWith(phone: phone, clearPhoneErrorOther: true));
  }

  void emailChanged(String value) {
    final email = EmailValidator.dirty(value);
    emit(state.copyWith(email: email, clearPhoneErrorOther: true));
  }

  void otpChanged(String value) {
    final otp = OtpValidator.dirty(value);
    emit(state.copyWith(otp: otp));
  }

  void clearOtp() {
    emit(state.copyWith(otp: const OtpValidator.dirty(''), otpError: null));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(password: password));
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = ConfirmedPassword.dirty(
      value: value,
      originalPassword: state.password.value,
    );
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void toggleShowPassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  Future<bool> sendOtp() async {
    try {
      emit(state.copyWith(isLoading: true));
      _startOtpResendTimer();
      final result = await _sendOtpUsecase(
        SendOtpParams(
          type: state.method,
          countryCode: state.phone.value.countryCode,
          phone: state.phone.value.phoneNumber,
          email: state.email.value,
        ),
      );

      bool isSuccess = false;

      result.fold(
        (error) {
          switch (error.code) {
            case AuthConstants.userNotFoundCode:
              emit(state.copyWith(isShowNotRegisteredDialog: true));
              break;
            case AuthConstants.manyRequestOtp:
              emit(state.copyWith(isShowOtpBlockDialog: true));
              break;
            default:
              emit(state.copyWith(phoneErrorOther: error.message));
          }
          isSuccess = false;
        },
        (r) {
          isSuccess = true;
        },
      );

      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<bool> verifyOtp() async {
    try {
      bool needsReset = state.otpBlockTime != null && canVerifyOtp();

      if (needsReset) {
        emit(state.copyWith(otpWrongCount: 0, clearOtpBlockTime: true));
      }

      emit(state.copyWith(isLoading: true, otpError: ''));

      final result = await _verifyOtpUsecase(
        VerifyOtpParams(
          type: state.method,
          countryCode: state.phone.value.countryCode,
          phone: state.phone.value.phoneNumber,
          email: state.email.value,
          otp: state.otp.value,
        ),
      );

      bool isSuccess = false;

      result.fold(
        (error) {
          final newOtpWrongCount = state.otpWrongCount + 1;
          int? newOtpBlockTime = state.otpBlockTime;
          if (newOtpWrongCount >= otpWrongCount) {
            newOtpBlockTime = DateTime.now().millisecondsSinceEpoch;
          }
          emit(
            state.copyWith(
              otpError: error.message,
              otpWrongCount: newOtpWrongCount,
              otpBlockTime: newOtpBlockTime,
            ),
          );
        },
        (r) {
          emit(state.copyWith(otpWrongCount: 0, otpBlockTime: null));
          _tokenChangePassword = r.tokenToChangePw ?? '';
          isSuccess = true;
        },
      );

      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  bool canVerifyOtp() {
    return state.otpBlockTime == null ||
        DateTime.now().millisecondsSinceEpoch - state.otpBlockTime! >
            otpBlockTime;
  }

  void _startOtpResendTimer() {
    if (_otpResendTimer != null) {
      _otpResendTimer?.cancel();
    }
    emit(state.copyWith(otpResendTime: otpResendTime));
    _otpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.copyWith(otpResendTime: state.otpResendTime - 1));
      if (state.otpResendTime == 0) {
        timer.cancel();
      }
    });
  }

  void hideNotRegisteredDialog() {
    emit(state.copyWith(isShowNotRegisteredDialog: false));
  }

  void hideOtpBlockDialog() {
    emit(state.copyWith(isShowOtpBlockDialog: false));
  }

  Future<bool> changePassword() async {
    try {
      emit(state.copyWith(isLoading: true));
      final result = await _changePasswordUsecase(
        ChangePasswordParams(
          email:
              state.method == ForgotPasswordType.email
                  ? state.email.value
                  : null,
          phone:
              state.method == ForgotPasswordType.phone
                  ? state.phone.value.phoneNumber
                  : null,
          countryCode:
              state.method == ForgotPasswordType.phone
                  ? state.phone.value.countryCode
                  : null,
          password: state.password.value,
          tokenChangePassword: _tokenChangePassword,
        ),
      );

      bool isSuccess = false;

      result.fold(
        (error) {
          isSuccess = false;
        },
        (r) {
          isSuccess = true;
        },
      );

      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      emit(
        state.copyWith(
          isLoading: false,
          formValues: FormValues(
            phone:
                '${state.phone.value.countryCode}${state.phone.value.phoneNumber}',
            email: state.email.value,
            password: state.password.value,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _otpResendTimer?.cancel();
    return super.close();
  }
}
