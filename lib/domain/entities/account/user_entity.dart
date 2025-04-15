import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/domain/entities/phone/phone_entity.dart';

class UserEntity {
  final int userId;
  final int maxProfile;
  final LoginType loginType;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? country;
  final PhoneEntity? phoneInfo;

  UserEntity({
    required this.userId,
    required this.maxProfile,
    required this.loginType,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.country,
    this.phoneInfo,
  });
}
