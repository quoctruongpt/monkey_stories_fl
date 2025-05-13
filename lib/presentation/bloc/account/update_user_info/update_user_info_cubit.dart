import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/validators/email.dart';
import 'package:monkey_stories/core/validators/name.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/entities/phone/phone_entity.dart';
import 'package:monkey_stories/domain/usecases/account/update_user_info_usecase.dart';
import 'package:monkey_stories/domain/usecases/auth/confirm_password_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

part 'update_user_info_state.dart';

class UpdateUserInfoCubit extends Cubit<UpdateUserInfoState> {
  final UpdateUserInfoUsecase _updateUserInfoUsecase;
  final ConfirmPasswordUsecase _confirmPasswordUsecase;
  final UserCubit _userCubit;

  UpdateUserInfoCubit({
    required UpdateUserInfoUsecase updateUserInfoUsecase,
    required UserCubit userCubit,
    required ConfirmPasswordUsecase confirmPasswordUsecase,
  }) : _updateUserInfoUsecase = updateUserInfoUsecase,
       _confirmPasswordUsecase = confirmPasswordUsecase,
       _userCubit = userCubit,
       super(UpdateUserInfoState()) {
    init();
  }

  void init() {
    emit(
      state.copyWith(
        name: NameValidator.dirty(_userCubit.state.user?.name ?? ''),
        email: EmailValidator.dirty(_userCubit.state.user?.email ?? ''),
        phone: PhoneValidator.dirty(
          PhoneNumberInput(
            countryCode: _userCubit.state.user?.phoneInfo?.countryCode ?? '',
            phoneNumber: _userCubit.state.user?.phoneInfo?.phone ?? '',
          ),
        ),
      ),
    );
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: NameValidator.dirty(value)));
    checkButtonEnabled();
  }

  void countryCodeInit(String value) {
    emit(
      state.copyWith(
        phone: PhoneValidator.dirty(
          PhoneNumberInput(
            countryCode: value,
            phoneNumber: state.phone.value.phoneNumber,
          ),
        ),
      ),
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
      ),
    );
    checkButtonEnabled();
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: EmailValidator.dirty(value)));
    checkButtonEnabled();
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: Password.dirty(value)));
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

  Future<void> confirmPassword() async {
    emit(
      state.copyWith(
        isPasswordConfirming: true,
        clearPasswordErrorMessage: true,
      ),
    );
    try {
      final result = await _confirmPasswordUsecase.call(state.password.value);
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
      final result = await _updateUserInfoUsecase.call(
        UpdateUserInfoUsecaseParams(
          name: state.name.value,
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
              name: state.name.value,
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
