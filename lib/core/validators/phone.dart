import 'package:formz/formz.dart';

class PhoneNumberInput {
  final String countryCode;
  final String phoneNumber;

  const PhoneNumberInput({
    required this.countryCode,
    required this.phoneNumber,
  });

  @override
  String toString() => '$countryCode$phoneNumber';

  Map<String, String> toJson() => {
    'countryCode': countryCode,
    'phoneNumber': phoneNumber,
  };
}

class PhoneValidator extends FormzInput<PhoneNumberInput, String> {
  PhoneValidator.pure({String? countryCode})
    : super.pure(
        PhoneNumberInput(countryCode: countryCode ?? '', phoneNumber: ''),
      );

  const PhoneValidator.dirty(PhoneNumberInput value) : super.dirty(value);

  @override
  String? validator(PhoneNumberInput value) {
    if (value.phoneNumber.isEmpty || value.countryCode.isEmpty) {
      return 'validation.phone.empty';
    }

    // Kiểm tra độ dài số điện thoại (ví dụ: ít nhất 6 chữ số)
    if (value.phoneNumber.length < 6 || value.phoneNumber.length > 15) {
      return 'validation.phone.length';
    }

    final regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(value.phoneNumber)) {
      return 'validation.phone.invalid';
    }

    return null;
  }
}
