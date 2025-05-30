import 'package:monkey_stories/core/constants/purchased.dart';

class PurchasedInfoEntity {
  final bool isEnrolled;
  final int timeExpired;
  final bool isPurchased;
  final bool isActive;
  final int freeDays;
  final bool isFreeUser;
  final int timeActive;
  final int profileTrial;

  PurchasedInfoEntity({
    required this.isEnrolled,
    required this.timeExpired,
    required this.isPurchased,
    required this.isActive,
    required this.freeDays,
    required this.isFreeUser,
    required this.timeActive,
    this.profileTrial = 0,
  });

  factory PurchasedInfoEntity.fromJson(Map<String, dynamic> json) {
    return PurchasedInfoEntity(
      isEnrolled: json['isEnrolled'],
      timeExpired: json['timeExpired'],
      isPurchased: json['isPurchased'],
      isActive: json['isActive'],
      freeDays: json['freeDays'],
      isFreeUser: json['isFreeUser'],
      timeActive: json['timeActive'],
      profileTrial: json['profileTrial'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnrolled': isEnrolled,
      'timeExpired': timeExpired,
      'isPurchased': isPurchased,
      'isActive': isActive,
      'freeDays': freeDays,
      'isFreeUser': isFreeUser,
      'timeActive': timeActive,
      'profileTrial': profileTrial,
    };
  }

  PurchasedStatus get status {
    if (!isEnrolled) {
      return PurchasedStatus.notEnrolled;
    }

    if (profileTrial != 0) {
      return PurchasedStatus.trial;
    }

    if (isFreeUser) {
      return PurchasedStatus.free;
    }

    if (isActive) {
      return PurchasedStatus.active;
    }

    return PurchasedStatus.expired;
  }

  bool get isPaidUser {
    return isActive;
  }
}
