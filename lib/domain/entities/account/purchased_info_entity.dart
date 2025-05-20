import 'package:monkey_stories/core/constants/purchased.dart';

class PurchasedInfoEntity {
  final bool isEnrolled;
  final int timeExpired;
  final bool isPurchased;
  final bool isActive;
  final int freeDays;
  final bool isFreeUser;
  final int timeActive;

  PurchasedInfoEntity({
    required this.isEnrolled,
    required this.timeExpired,
    required this.isPurchased,
    required this.isActive,
    required this.freeDays,
    required this.isFreeUser,
    required this.timeActive,
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
    };
  }

  PurchasedStatus get status {
    if (isActive) {
      return PurchasedStatus.active;
    }
    if (isFreeUser) {
      return PurchasedStatus.expired;
    }
    if (freeDays > 0) {
      return PurchasedStatus.trial;
    }
    return PurchasedStatus.notEnrolled;
  }

  bool get isPaidUser {
    return isActive;
  }
}
