import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/phone/phone_model.dart';
import 'package:monkey_stories/domain/entities/account/user_entity.dart';

final logger = Logger('UserModel');

class User {
  final int userId;
  final int maxProfile;
  final LoginType loginType;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? country;
  final PhoneModel? phoneInfo;
  final bool? hasPassword;

  User({
    required this.userId,
    required this.loginType,
    required this.maxProfile,
    this.email,
    this.name,
    this.phone,
    this.avatar,
    this.country,
    this.phoneInfo,
    this.hasPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        userId: json['users_id'],
        loginType: LoginType.fromValue(json['identity_login']),
        maxProfile:
            json['max_profile'].runtimeType == int ? json['max_profile'] : 3,
        email: json['email'],
        name: json['name'],
        phone: json['phone'],
        avatar: json['avatar'],
        country: json['country'],
        phoneInfo:
            json['phone_info'] != null
                ? PhoneModel.fromJson({
                  'country_code': json['phone_info']['phone_code'],
                  'phone': json['phone_info']['phone'],
                })
                : null,
        hasPassword: json['password'],
      );
    } catch (e) {
      logger.severe('User.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'login_type': loginType.value,
      'max_profile': maxProfile,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'country': country,
      'phone_info': phoneInfo?.toJson(),
      'password': hasPassword,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      loginType: loginType,
      maxProfile: maxProfile,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      country: country,
      phoneInfo: phoneInfo?.toEntity(),
      hasPassword: hasPassword,
    );
  }
}
