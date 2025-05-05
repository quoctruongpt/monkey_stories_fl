import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/validators/license_code.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/entities/active_license/account_info.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/usecases/active_license/verify_license_code.dart';
import 'package:monkey_stories/domain/usecases/auth/check_phone_number_usecase.dart';

part 'active_license_state.dart';

final logger = Logger('ActiveLicenseCubit');

class ActiveLicenseCubit extends Cubit<ActiveLicenseState> {
  final VerifyLicenseCodeUseCase _verifyLicenseCodeUseCase;
  final CheckPhoneNumberUsecase _checkPhoneNumberUsecase;

  ActiveLicenseCubit({
    required VerifyLicenseCodeUseCase verifyLicenseCodeUseCase,
    required CheckPhoneNumberUsecase checkPhoneNumberUsecase,
  }) : _verifyLicenseCodeUseCase = verifyLicenseCodeUseCase,
       _checkPhoneNumberUsecase = checkPhoneNumberUsecase,
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
}
