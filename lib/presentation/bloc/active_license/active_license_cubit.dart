import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/validators/confirm_password.dart';
import 'package:monkey_stories/core/validators/license_code.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/entities/active_license/account_info.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/usecases/active_license/verify_license_code.dart';
import 'package:monkey_stories/domain/usecases/auth/check_phone_number_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/sign_up_usecase.dart';
import 'package:monkey_stories/domain/usecases/active_license/link_cod_to_this_account.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

part 'active_license_state.dart';

final logger = Logger('ActiveLicenseCubit');

class ActiveLicenseCubit extends Cubit<ActiveLicenseState> {
  final VerifyLicenseCodeUseCase _verifyLicenseCodeUseCase;
  final CheckPhoneNumberUsecase _checkPhoneNumberUsecase;
  final SignUpUsecase _signUpUsecase;
  final LinkCodToThisAccountUseCase _linkCodToThisAccountUseCase;
  final UserCubit _userCubit;
  final ProfileCubit _profileCubit;

  ActiveLicenseCubit({
    required VerifyLicenseCodeUseCase verifyLicenseCodeUseCase,
    required CheckPhoneNumberUsecase checkPhoneNumberUsecase,
    required SignUpUsecase signUpUsecase,
    required LinkCodToThisAccountUseCase linkCodToThisAccountUseCase,
    required UserCubit userCubit,
    required ProfileCubit profileCubit,
  }) : _verifyLicenseCodeUseCase = verifyLicenseCodeUseCase,
       _checkPhoneNumberUsecase = checkPhoneNumberUsecase,
       _signUpUsecase = signUpUsecase,
       _linkCodToThisAccountUseCase = linkCodToThisAccountUseCase,
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

  bool checkValidLicense(String value) {
    return LicenseCodeValidator.dirty(value).isValid;
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

  void clearVerifyError() {
    emit(state.copyWith(clearVerifyError: true));
  }

  void clearPhoneError() {
    emit(state.copyWith(clearPhoneError: true));
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
      final signUpResult = await _signUpUsecase.call(
        SignUpParams(
          countryCode: state.phone.value.countryCode,
          phoneNumber: state.phone.value.phoneNumber,
          password: state.password.value,
          isUpgrade: false,
        ),
      );

      if (signUpResult.isRight()) {
        final linkAccountResult = await _linkCodToThisAccountUseCase.call(
          LinkCodToThisAccountParams(
            newAccessToken: state.licenseInfo!.newAccessToken,
          ),
        );

        if (linkAccountResult.isRight()) {
          emit(state.copyWith(isSuccess: true));
        } else {
          final failure = linkAccountResult.swap().getOrElse(
            (e) => throw Exception(),
          );
          emit(state.copyWith(linkAccountError: failure.message));
        }

        return;
      }

      throw Exception();
    } catch (e) {
      emit(state.copyWith(linkAccountError: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
