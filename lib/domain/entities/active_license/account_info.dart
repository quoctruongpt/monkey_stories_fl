class AccountInfoEntity {
  final String oldAccessToken;
  final UserInfoEntity userInfo;
  final List<ProfileInfoEntity> profiles;

  AccountInfoEntity({
    required this.oldAccessToken,
    required this.userInfo,
    required this.profiles,
  });
}

class UserInfoEntity {
  final int id;
  final String? name;
  final String? email;
  final String? phone;

  UserInfoEntity({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
  });
}

class ProfileInfoEntity {
  final int id;
  final String name;

  ProfileInfoEntity({required this.id, required this.name});
}
