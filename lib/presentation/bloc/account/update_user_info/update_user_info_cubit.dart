import 'package:country_code_picker/country_code_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/core/validators/confirm_password.dart';
import 'package:monkey_stories/core/validators/email.dart';
import 'package:monkey_stories/core/validators/name.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/entities/phone/phone_entity.dart';
import 'package:monkey_stories/domain/usecases/account/update_user_info_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/confirm_password_usecase.dart';
import 'package:monkey_stories/domain/usecases/system/get_country_code_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

part 'update_user_info_state.dart';

class UpdateUserInfoCubit extends Cubit<UpdateUserInfoState> {
  final UpdateUserInfoUsecase _updateUserInfoUsecase;
  final ConfirmPasswordUsecase _confirmPasswordUsecase;
  final UserCubit _userCubit;
  final GetCountryCodeUsecase _getCountryCodeUsecase;

  UpdateUserInfoCubit({
    required UpdateUserInfoUsecase updateUserInfoUsecase,
    required UserCubit userCubit,
    required ConfirmPasswordUsecase confirmPasswordUsecase,
    required GetCountryCodeUsecase getCountryCodeUsecase,
  }) : _updateUserInfoUsecase = updateUserInfoUsecase,
       _confirmPasswordUsecase = confirmPasswordUsecase,
       _userCubit = userCubit,
       _getCountryCodeUsecase = getCountryCodeUsecase,
       super(UpdateUserInfoState()) {
    init();
  }

  Future<void> init() async {
    final user = _userCubit.state.user;
    final phone =
        user?.phoneInfo?.phone != null
            ? user!.phoneInfo!.phone.startsWith('0')
                ? user.phoneInfo!.phone.replaceFirst('0', '')
                : user.phoneInfo!.phone
            : null;
    var countryCode = user?.phoneInfo?.countryCode;

    if (countryCode == null) {
      final response = await _getCountryCodeUsecase.call(NoParams());
      response.fold((failure) {}, (success) {
        countryCode = CountryCode.fromCountryCode(success).dialCode;
      });
    }

    emit(
      state.copyWith(
        name: NameValidator.dirty(user?.name ?? ''),
        email: EmailValidator.dirty(user?.email ?? ''),
        phone:
            phone != null
                ? PhoneValidator.dirty(
                  PhoneNumberInput(
                    countryCode: countryCode ?? '+84',
                    phoneNumber: phone,
                  ),
                )
                : PhoneValidator.pure(countryCode: countryCode),
      ),
    );
  }

  void nameChanged(String value) {
    emit(
      state.copyWith(name: NameValidator.dirty(value), clearErrorMessage: true),
    );
    checkButtonEnabled();
  }

  void countryCodeChanged(String value) {
    emit(
      state.copyWith(
        phone: PhoneValidator.dirty(
          PhoneNumberInput(
            countryCode: value,
            phoneNumber: state.phone.value.phoneNumber,
          ),
        ),
        clearErrorMessage: true,
      ),
    );
    checkButtonEnabled();
  }

  void phoneChanged(String value) {
    emit(
      state.copyWith(
        phone: PhoneValidator.dirty(
          PhoneNumberInput(
            countryCode: state.phone.value.countryCode,
            phoneNumber: value,
          ),
        ),
        clearErrorMessage: true,
      ),
    );
    checkButtonEnabled();
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: EmailValidator.dirty(value),
        clearErrorMessage: true,
      ),
    );
    checkButtonEnabled();
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: Password.dirty(value),
        rePassword: ConfirmedPassword.dirty(
          originalPassword: value,
          value: state.rePassword.value,
        ),
      ),
    );
  }

  void rePasswordChanged(String value) {
    emit(
      state.copyWith(
        rePassword: ConfirmedPassword.dirty(
          originalPassword: state.password.value,
          value: value,
        ),
      ),
    );
  }

  void checkButtonEnabled() {
    final isNameError =
        state.name.value != _userCubit.state.user?.name &&
        state.name.isNotValid;
    final isPhoneError =
        (state.phone.value.countryCode !=
                _userCubit.state.user?.phoneInfo?.countryCode ||
            state.phone.value.phoneNumber !=
                _userCubit.state.user?.phoneInfo?.phone) &&
        state.phone.isNotValid;
    final isEmailError =
        (state.email.value != _userCubit.state.user?.email) &&
        state.email.isNotValid;

    emit(
      state.copyWith(
        isButtonEnabled:
            (state.name.value != _userCubit.state.user?.name ||
                state.phone.value.phoneNumber !=
                    _userCubit.state.user?.phoneInfo?.phone ||
                state.phone.value.countryCode.replaceAll('+', '') !=
                    _userCubit.state.user?.phoneInfo?.countryCode.replaceAll(
                      '+',
                      '',
                    ) ||
                state.email.value != _userCubit.state.user?.email) &&
            (!isNameError && !isPhoneError && !isEmailError),
      ),
    );
  }

  Future<void> confirmPassword(bool isCreatePassword) async {
    emit(
      state.copyWith(
        isPasswordConfirming: true,
        clearPasswordErrorMessage: true,
      ),
    );
    try {
      final result = await _confirmPasswordUsecase.call(
        ConfirmPasswordParams(
          password: isCreatePassword ? null : state.password.value,
          newPassword: isCreatePassword ? state.password.value : null,
        ),
      );
      result.fold(
        (error) {
          emit(state.copyWith(passwordErrorMessage: error.message));
        },
        (success) {
          emit(
            state.copyWith(
              passwordErrorMessage: null,
              isPasswordAuthenticated: true,
            ),
          );
          _userCubit.updateUser(
            _userCubit.state.user!.copyWith(hasPassword: true),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(passwordErrorMessage: 'error'));
    } finally {
      emit(state.copyWith(isPasswordConfirming: false));
    }
  }

  Future<void> updateUserInfo() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final name = state.name.value.trim();
      final result = await _updateUserInfoUsecase.call(
        UpdateUserInfoUsecaseParams(
          name: name,
          phone: state.phone.value.phoneNumber,
          countryCode: state.phone.value.countryCode,
          email: state.email.value,
          phoneString:
              '${state.phone.value.countryCode}${state.phone.value.phoneNumber}',
        ),
      );

      result.fold(
        (error) {
          emit(state.copyWith(errorMessage: error.message));
        },
        (success) {
          emit(state.copyWith(isSuccess: true));
          _userCubit.updateUser(
            _userCubit.state.user!.copyWith(
              name: name,
              phone: state.phone.value.phoneNumber,
              country: state.phone.value.countryCode,
              email: state.email.value,
              phoneInfo: PhoneEntity(
                countryCode: state.phone.value.countryCode,
                phone: state.phone.value.phoneNumber,
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
