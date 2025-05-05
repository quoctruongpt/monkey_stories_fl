import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/constants/leave_contact.dart';
import 'package:monkey_stories/core/validators/phone.dart';
import 'package:monkey_stories/domain/usecases/leave_contact/save_contact_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';

part 'leave_contact_state.dart';

class LeaveContactCubit extends Cubit<LeaveContactState> {
  final SaveContactUsecase _saveContactUsecase;
  final ProfileCubit _profileCubit;
  final PurchasedCubit _purchasedCubit;

  LeaveContactCubit({
    required SaveContactUsecase saveContactUsecase,
    required ProfileCubit profileCubit,
    required PurchasedCubit purchasedCubit,
  }) : _saveContactUsecase = saveContactUsecase,
       _profileCubit = profileCubit,
       _purchasedCubit = purchasedCubit,
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

  void roleChanged(LeaveContactRole? role) {
    emit(state.copyWith(role: role));
  }

  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    try {
      final result = await _saveContactUsecase(
        ContactParams(
          phone: state.phone.value.phoneNumber,
          countryCode: state.phone.value.countryCode,
          productId: _purchasedCubit.state.purchasingItem?.id,
          utmMedium: 'app',
          utmCampaign: 'app',
          profileId: _profileCubit.state.currentProfile?.id,
          role: state.role,
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
