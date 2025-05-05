import 'dart:convert';

import 'package:monkey_stories/core/constants/shared_pref_keys.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveListProfile(List<ProfileEntity> profiles);
  Future<List<ProfileEntity>> getListProfile();
  Future<void> addProfile(ProfileEntity profile);
  Future<void> clearProfile();
  Future<void> cacheCurrentProfile(int profileId);
  Future<int?> getCurrentProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProfileEntity>> getListProfile() async {
    final list = sharedPreferences.getStringList(SharedPrefKeys.profileList);
    return list?.map((e) => ProfileEntity.fromJson(jsonDecode(e))).toList() ??
        [];
  }

  @override
  Future<void> saveListProfile(List<ProfileEntity> profiles) async {
    await sharedPreferences.setStringList(
      SharedPrefKeys.profileList,
      profiles.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  Future<void> addProfile(ProfileEntity profile) async {
    final list = await getListProfile();
    list.add(profile);
    await saveListProfile(list);
  }

  @override
  Future<void> clearProfile() async {
    await sharedPreferences.remove(SharedPrefKeys.profileList);
  }

  @override
  Future<void> cacheCurrentProfile(int profileId) async {
    await sharedPreferences.setInt(SharedPrefKeys.currentProfile, profileId);
  }

  @override
  Future<int?> getCurrentProfile() async {
    return sharedPreferences.getInt(SharedPrefKeys.currentProfile);
  }
}
