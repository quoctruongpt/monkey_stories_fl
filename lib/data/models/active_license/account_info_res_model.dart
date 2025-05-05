import 'package:monkey_stories/domain/entities/active_license/account_info.dart';

class AccountInfoResModel {
  final String oldAccessToken;
  final UserInfoResModel userInfo;
  final List<ProfileInfoResModel> profiles;

  AccountInfoResModel({
    required this.oldAccessToken,
    required this.userInfo,
    required this.profiles,
  });

  factory AccountInfoResModel.fromJson(Map<String, dynamic> json) {
    return AccountInfoResModel(
      oldAccessToken: json['old_access_token'],
      userInfo: UserInfoResModel.fromJson(json['user_info']),
      profiles:
          json['list_profile']
              .map((item) => ProfileInfoResModel.fromJson(item))
              .toList(),
    );
  }

  AccountInfoEntity toEntity() {
    return AccountInfoEntity(
      oldAccessToken: oldAccessToken,
      userInfo: userInfo.toEntity(),
      profiles: profiles.map((item) => item.toEntity()).toList(),
    );
  }
}

class UserInfoResModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  UserInfoResModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserInfoResModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  UserInfoEntity toEntity() {
    return UserInfoEntity(id: id, name: name, phone: phone, email: email);
  }
}

class ProfileInfoResModel {
  final int id;
  final String name;

  ProfileInfoResModel({required this.id, required this.name});

  factory ProfileInfoResModel.fromJson(Map<String, dynamic> json) {
    return ProfileInfoResModel(id: json['id'], name: json['name']);
  }

  ProfileInfoEntity toEntity() {
    return ProfileInfoEntity(id: id, name: name);
  }
}
