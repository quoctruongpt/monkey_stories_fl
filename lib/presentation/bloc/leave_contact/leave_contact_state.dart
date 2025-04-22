part of 'leave_contact_cubit.dart';

class LeaveContactState extends Equatable {
  const LeaveContactState({
    this.phone = const PhoneValidator.pure(),
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final PhoneValidator phone;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  LeaveContactState copyWith({
    PhoneValidator? phone,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool? clearErrorMessage,
  }) {
    return LeaveContactState(
      phone: phone ?? this.phone,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage:
          clearErrorMessage == true ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [phone, isSubmitting, isSuccess, errorMessage];
}
