import 'package:monkey_stories/core/constants/purchased.dart';

class DefaultProperties {
  final PurchasedStatus? userType;
  final int? age;
  final int? userId;
  final int? profileId;

  DefaultProperties({this.userType, this.age, this.userId, this.profileId});

  Map<String, dynamic> toJson() {
    return {
      'user_type': userType?.value,
      'age': age,
      'user_id': userId,
      'profile_id': profileId,
    };
  }
}
