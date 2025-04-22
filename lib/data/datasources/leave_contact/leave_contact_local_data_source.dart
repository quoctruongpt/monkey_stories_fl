import 'dart:convert';

import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/leave_contact/contact_local_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LeaveContactLocalDataSource {
  Future<void> saveContact(ContactLocalModel contact);
  Future<ContactLocalModel> getContact();
  Future<bool> isContactSaved();
  Future<void> clearContact();
}

class LeaveContactLocalDataSourceImpl extends LeaveContactLocalDataSource {
  final SharedPreferences sharedPreferences;

  LeaveContactLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveContact(ContactLocalModel contact) async {
    await sharedPreferences.setString(
      SharedPrefKeys.leaveContact,
      jsonEncode(contact.toJson()),
    );
  }

  @override
  Future<ContactLocalModel> getContact() async {
    final contact = sharedPreferences.getString(SharedPrefKeys.leaveContact);
    return ContactLocalModel.fromJson(jsonDecode(contact ?? '{}'));
  }

  @override
  Future<bool> isContactSaved() async {
    final contact = sharedPreferences.getString(SharedPrefKeys.leaveContact);
    return contact != null;
  }

  @override
  Future<void> clearContact() async {
    await sharedPreferences.remove(SharedPrefKeys.leaveContact);
  }
}
