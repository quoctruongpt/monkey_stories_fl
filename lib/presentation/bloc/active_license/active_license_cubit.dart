import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/validators/confirm_password.dart';
import 'package:monkey_stories/core/validators/license_code.dart';
import 'package:monkey_stories/core/validators/otp.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/entities/active_license/account_info.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/usecases/active_license/verify_license_code.dart';
import 'package:monkey_stories/domain/usecases/auth/check_phone_number_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/login_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/send_otp_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_usecase.dart';
import 'package:monkey_stories/domain/usecases/active_license/link_cod_to_this_account.dart';
import 'package:monkey_stories/domain/usecases/active_license/link_cod_to_account.dart';
import 'package:monkey_stories/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/core/constants/active_license.dart';

part 'active_license_state.dart';

final logger = Logger('ActiveLicenseCubit');
const otpResendTime = 60;

enum PositionShowWarning {
  none,
  inputLicense,
  lastLoginAccount,
  inputPhone,
  inputOtp,
}

class ActiveLicenseCubit extends Cubit<ActiveLicenseState> {
  final VerifyLicenseCodeUseCase _verifyLicenseCodeUseCase;
  final CheckPhoneNumberUsecase _checkPhoneNumberUsecase;
  final SignUpUsecase _signUpUsecase;
  final LinkCodToThisAccountUseCase _linkCodToThisAccountUseCase;
  final LinkCodToAccountUseCase _linkCodToAccountUseCase;
  final LoginUsecase _loginUsecase;
  final SendOtpUsecase _sendOtpUsecase;
  final VerifyOtpUsecase _verifyOtpUsecase;
  final UserCubit _userCubit;
  final ProfileCubit _profileCubit;

  Timer? _otpResendTimer;

  ActiveLicenseCubit({
    required VerifyLicenseCodeUseCase verifyLicenseCodeUseCase,
    required CheckPhoneNumberUsecase checkPhoneNumberUsecase,
    required SignUpUsecase signUpUsecase,
    required LinkCodToThisAccountUseCase linkCodToThisAccountUseCase,
    required LinkCodToAccountUseCase linkCodToAccountUseCase,
    required LoginUsecase loginUsecase,
    required SendOtpUsecase sendOtpUsecase,
    required VerifyOtpUsecase verifyOtpUsecase,
    required UserCubit userCubit,
    required ProfileCubit profileCubit,
  }) : _verifyLicenseCodeUseCase = verifyLicenseCodeUseCase,
       _checkPhoneNumberUsecase = checkPhoneNumberUsecase,
       _signUpUsecase = signUpUsecase,
       _linkCodToThisAccountUseCase = linkCodToThisAccountUseCase,
       _linkCodToAccountUseCase = linkCodToAccountUseCase,
       _loginUsecase = loginUsecase,
       _sendOtpUsecase = sendOtpUsecase,
       _verifyOtpUsecase = verifyOtpUsecase,
       _profileCubit = profileCubit,
       _userCubit = userCubit,
       super(const ActiveLicenseState());

  void showScanner() {
    emit(state.copyWith(isShowScanner: true));
  }

  void hideScanner() {
    emit(state.copyWith(isShowScanner: false));
  }

  void changeLicenseCode(String value) {
    emit(state.copyWith(licenseCode: LicenseCodeValidator.dirty(value)));
  }

  void otpChanged(String value) {
    emit(state.copyWith(otp: OtpValidator.dirty(value)));
  }

  bool checkValidLicense(String value) {
    return LicenseCodeValidator.dirty(value).isValid;
  }

  void clearVerifyError() {
    emit(state.copyWith(clearVerifyError: true));
  }

  void clearPhoneError() {
    emit(state.copyWith(clearPhoneError: true));
  }

  void clearLoginError() {
    emit(state.copyWith(clearLoginError: true));
  }

  void clearSendOtpError() {
    emit(state.copyWith(clearSendOtpError: true));
  }

  void clearLinkAccountError() {
    emit(state.copyWith(clearLinkAccountError: true));
  }

  void closeMergeLifetimeWarning() {
    emit(state.copyWith(showMergeLifetimeWarning: PositionShowWarning.none));
  }

  void closeMergeToLifetimeAccountWarning() {
    emit(state.copyWith(isShowMergeToLifetimeAccountWarning: false));
  }

  void phoneChanged(String phone) {
    emit(
      state.copyWith(
        phone: PhoneValidator.dirty(
          PhoneNumberInput(
            countryCode: state.phone.value.countryCode,
            phoneNumber: phone,
          ),
        ),
      ),
    );
  }

  void countryCodeChanged(String countryCode) {
    emit(
      state.copyWith(
        phone: PhoneValidator.dirty(
          PhoneNumberInput(
            countryCode: countryCode,
            phoneNumber: state.phone.value.phoneNumber,
          ),
        ),
      ),
    );
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: Password.dirty(password)));
  }

  void rePasswordChanged(String password) {
    emit(
      state.copyWith(
        rePassword: ConfirmedPassword.dirty(
          originalPassword: state.password.value,
          value: password,
        ),
      ),
    );
  }

  void handlePressedContinueLicense() {
    verifyLicenseCode();
  }

  Future<void> activateLicenseWithCurrentAccount(
    PositionShowWarning position,
    bool checkWarning,
  ) async {
    logger.info('checkWarning: $checkWarning');
    emit(state.copyWith(isLoading: true));

    try {
      final linkAccountResult = await _linkCodToThisAccountUseCase.call(
        LinkCodToThisAccountParams(
          newAccessToken: state.licenseInfo!.newAccessToken,
          checkWarning: checkWarning,
        ),
      );

      if (linkAccountResult.isRight()) {
        emit(state.copyWith(isSuccess: true));
      } else {
        final failure = linkAccountResult.swap().getOrElse(
          (e) => throw Exception(),
        );
        if (failure.code == ActiveLicenseCode.mergeLifetimeToPaid) {
          emit(state.copyWith(showMergeLifetimeWarning: position));
        } else if (failure.code == ActiveLicenseCode.mergeToLifetimeAccount) {
          emit(state.copyWith(isShowMergeToLifetimeAccountWarning: true));
        } else {
          emit(state.copyWith(linkAccountError: failure.message));
        }
      }
    } catch (e) {
      logger.severe(e);
      emit(state.copyWith(linkAccountError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> verifyLicenseCode() async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _verifyLicenseCodeUseCase.call(
        VerifyLicenseCodeParams(licenseCode: state.licenseCode.value),
      );

      result.fold(
        (error) {
          emit(state.copyWith(verifyLicenseError: error.message));
        },
        (info) {
          emit(state.copyWith(licenseInfo: info));
        },
      );
    } catch (e) {
      logger.severe(e);
      emit(state.copyWith(verifyLicenseError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> checkPhoneNumber() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearPhoneInfo: true,
        clearPhoneError: true,
      ),
    );
    try {
      final result = await _checkPhoneNumberUsecase.call(
        CheckPhoneNumberParams(
          countryCode: state.phone.value.countryCode,
          phoneNumber: state.phone.value.phoneNumber,
        ),
      );

      result.fold(
        (phoneInfo) {
          emit(
            state.copyWith(phoneInfo: phoneInfo.data, isNewPhoneValid: false),
          );
        },
        (success) {
          emit(state.copyWith(isNewPhoneValid: true));
        },
      );
    } catch (e) {
      logger.severe(e);
      emit(state.copyWith(checkPhoneError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> createPasswordPressed() async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = _userCubit.state.user;
      final signUpResult = await _signUpUsecase.call(
        SignUpParams(
          countryCode: state.phone.value.countryCode,
          phoneNumber: state.phone.value.phoneNumber,
          password: state.password.value,
          isUpgrade: user?.loginType == LoginType.skip,
        ),
      );

      if (signUpResult.isRight()) {
        await activateLicenseWithCurrentAccount(
          PositionShowWarning.none,
          false,
        );

        return;
      }

      throw Exception();
    } catch (e) {
      emit(state.copyWith(linkAccountError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> activateOnLastLoginAccount(bool checkWarning) async {
    emit(state.copyWith(isLoading: true));

    try {
      final linkAccountResult = await _linkCodToAccountUseCase.call(
        LinkCodToAccountParams(
          oldAccessToken: state.licenseInfo!.accountInfo!.oldAccessToken,
          newAccessToken: state.licenseInfo!.newAccessToken,
          isSocial: false,
          phone: state.licenseInfo!.accountInfo!.userInfo.phone,
          email: state.licenseInfo!.accountInfo!.userInfo.email,
          checkWarning: checkWarning,
        ),
      );

      linkAccountResult.fold(
        (failure) {
          if (failure.code == ActiveLicenseCode.mergeLifetimeToPaid) {
            emit(
              state.copyWith(
                showMergeLifetimeWarning: PositionShowWarning.lastLoginAccount,
              ),
            );
          } else if (failure.code == ActiveLicenseCode.mergeToLifetimeAccount) {
            emit(state.copyWith(isShowMergeToLifetimeAccountWarning: true));
          } else {
            emit(state.copyWith(linkAccountError: failure.message));
          }
        },
        (_) {
          emit(state.copyWith(isSuccess: true));
        },
      );
    } catch (e) {
      logger.severe(e);
      emit(state.copyWith(linkAccountError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> activateByPhoneExist(bool checkWarning) async {
    emit(state.copyWith(isLoading: true));

    try {
      final loginResult = await _loginUsecase.call(
        LoginParams(
          loginType: LoginType.phone,
          phone:
              '${state.phone.value.countryCode}${state.phone.value.phoneNumber}',
          password: state.password.value,
        ),
      );

      if (loginResult.isRight()) {
        await activateLicenseWithCurrentAccount(
          PositionShowWarning.inputPhone,
          checkWarning,
        );
      } else {
        final failure = loginResult.swap().getOrElse((e) => throw Exception());
        emit(state.copyWith(loginError: failure.message));
      }
    } catch (e) {
      logger.severe(e);
      emit(state.copyWith(linkAccountError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<bool> sendOtp() async {
    try {
      emit(state.copyWith(isLoading: true));
      _startOtpResendTimer();
      final result = await _sendOtpUsecase(
        SendOtpParams(
          type: ForgotPasswordType.phone,
          countryCode: state.phone.value.countryCode,
          phone: state.phone.value.phoneNumber,
        ),
      );

      bool isSuccess = false;

      result.fold(
        (error) {
          emit(state.copyWith(sendOtpError: error.message));
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

  Future<void> verifyOtp(bool checkWarning) async {
    try {
      emit(state.copyWith(isLoading: true));

      final verifyOtpResult = await _verifyOtpUsecase(
        VerifyOtpParams(
          type: ForgotPasswordType.phone,
          countryCode: state.phone.value.countryCode,
          phone: state.phone.value.phoneNumber,
          otp: state.otp.value,
        ),
      );

      if (verifyOtpResult.isRight()) {
        final dataOtp = verifyOtpResult.getOrElse((e) => throw Exception());
        final linkAccountResult = await _linkCodToAccountUseCase.call(
          LinkCodToAccountParams(
            oldAccessToken: dataOtp.oldAccessToken ?? '',
            newAccessToken: state.licenseInfo!.newAccessToken,
            isSocial: false,
            phone:
                '${state.phone.value.countryCode}${state.phone.value.phoneNumber}',
            checkWarning: checkWarning,
          ),
        );

        if (linkAccountResult.isRight()) {
          emit(state.copyWith(isSuccess: true));
        } else {
          final failure = linkAccountResult.swap().getOrElse(
            (e) => throw Exception(),
          );
          if (failure.code == ActiveLicenseCode.mergeLifetimeToPaid) {
            emit(
              state.copyWith(
                showMergeLifetimeWarning: PositionShowWarning.inputOtp,
              ),
            );
          } else if (failure.code == ActiveLicenseCode.mergeToLifetimeAccount) {
            emit(state.copyWith(isShowMergeToLifetimeAccountWarning: true));
          } else {
            emit(state.copyWith(linkAccountError: failure.message));
          }
        }
      } else {
        emit(
          state.copyWith(
            sendOtpError:
                verifyOtpResult
                    .swap()
                    .getOrElse((e) => throw Exception())
                    .message,
          ),
        );
      }
    } catch (e) {
      logger.severe(e);
      emit(state.copyWith(sendOtpError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> handleSuccess() async {
    emit(state.copyWith(isLoading: true));

    try {
      await _userCubit.loadUpdate();
      await _profileCubit.getListProfile();
      emit(state.copyWith(isDone: true));
    } catch (e) {
      logger.severe(e);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
