import 'package:formz/formz.dart';

class NameValidator extends FormzInput<String, String> {
  const NameValidator.pure() : super.pure('');

  const NameValidator.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.name.empty';
    }
    if (value.length < 2 || value.length > 50) {
      return 'validation.name.length';
    }

    return null;
  }
}
