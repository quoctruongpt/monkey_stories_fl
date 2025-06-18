import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:monkey_stories/core/validators/confirm_password.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/domain/usecases/auth/confirm_password_usecase.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ConfirmPasswordUsecase _confirmPasswordUsecase;

  ChangePasswordCubit({required ConfirmPasswordUsecase confirmPasswordUsecase})
    : _confirmPasswordUsecase = confirmPasswordUsecase,
      super(const ChangePasswordState());

  void onCurrentPasswordChanged(String value) {
    final currentPassword = Password.dirty(value);
    emit(
      state.copyWith(
        currentPassword: currentPassword,
        status: Formz.validate([
          currentPassword,
          state.newPassword,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void onNewPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      value: value,
      originalPassword: state.currentPassword.value,
    );
    emit(
      state.copyWith(
        newPassword: newPassword,
        confirmPassword: confirmedPassword,
        status: Formz.validate([
          state.currentPassword,
          newPassword,
          confirmedPassword,
        ]),
      ),
    );
  }

  void onConfirmPasswordChanged(String value) {
    final confirmPassword = ConfirmedPassword.dirty(
      value: value,
      originalPassword: state.newPassword.value,
    );

    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        status: Formz.validate([
          state.currentPassword,
          state.newPassword,
          confirmPassword,
        ]),
      ),
    );
  }

  void toggleCurrentPasswordVisibility() {
    emit(
      state.copyWith(
        isCurrentPasswordObscured: !state.isCurrentPasswordObscured,
      ),
    );
  }

  void toggleNewPasswordVisibility() {
    emit(state.copyWith(isNewPasswordObscured: !state.isNewPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
      ),
    );
  }

  Future<void> submitChangePassword() async {
    if (!state.status) {
      // Optionally, you can emit a state to show a generic form error
      // if you don't want to rely only on individual field errors.
      // emit(state.copyWith(errorMessage: 'Vui lòng kiểm tra lại thông tin đã nhập.'));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        errorMessage: null,
        clearErrorMessage: true,
      ),
    );

    try {
      final result = await _confirmPasswordUsecase.call(
        ConfirmPasswordParams(
          password: state.currentPassword.value,
          newPassword: state.newPassword.value,
        ),
      );

      // The Usecase should ideally return Either<Failure, SuccessType> or similar
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              errorMessage:
                  failure.message, // Adapt based on your Failure object
            ),
          );
        },
        (_) {
          emit(state.copyWith(isSuccess: true));
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
