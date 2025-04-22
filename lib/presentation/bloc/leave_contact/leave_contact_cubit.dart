import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/usecases/leave_contact/save_contact_usecase.dart';

part 'leave_contact_state.dart';

class LeaveContactCubit extends Cubit<LeaveContactState> {
  final SaveContactUsecase _saveContactUsecase;
  LeaveContactCubit({required SaveContactUsecase saveContactUsecase})
    : _saveContactUsecase = saveContactUsecase,
      super(const LeaveContactState());

  void countryCodeChanged(String countryCode) {
    final phone = PhoneValidator.dirty(
      PhoneNumberInput(
        countryCode: countryCode,
        phoneNumber: state.phone.value.phoneNumber,
      ),
    );
    emit(state.copyWith(phone: phone));
  }

  void phoneChanged(String value) {
    final phone = PhoneValidator.dirty(
      PhoneNumberInput(
        countryCode: state.phone.value.countryCode,
        phoneNumber: value,
      ),
    );
    emit(state.copyWith(phone: phone));
  }

  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    try {
      final result = await _saveContactUsecase(
        ContactParams(
          phone: state.phone.value.phoneNumber,
          countryCode: state.phone.value.countryCode,
        ),
      );

      result.fold(
        (l) =>
            emit(state.copyWith(isSubmitting: false, errorMessage: l.message)),
        (r) {
          emit(state.copyWith(isSubmitting: false, isSuccess: true));
        },
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
