import 'package:monkey_stories/domain/entities/auth/verify_otp_entity.dart';

class VerifyOtpResponseModel {
  final String? tokenToChangePw;
  final String? oldAccessToken;

  VerifyOtpResponseModel({this.tokenToChangePw, this.oldAccessToken});

  static VerifyOtpResponseModel? fromJson(dynamic json) {
    // Xử lý trường hợp json là mảng rỗng
    if (json is List) {
      return null;
    }

    return VerifyOtpResponseModel(
      tokenToChangePw: json['token_to_change_pw'],
      oldAccessToken: json['old_access_token'],
    );
  }

  VerifyOtpEntity toEntity() {
    return VerifyOtpEntity(
      tokenToChangePw: tokenToChangePw,
      oldAccessToken: oldAccessToken,
    );
  }
}
