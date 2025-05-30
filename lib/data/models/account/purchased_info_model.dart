import 'package:monkey_stories/domain/entities/account/purchased_info_entity.dart';

class PurchasedInfoModel {
  final bool isEnrolled;
  final int timeExpired;
  final bool isPurchased;
  final bool isActive;
  final int freeDays;
  final bool isFreeUser;
  final int timeActive;
  final int profileTrial;

  PurchasedInfoModel({
    required this.isEnrolled,
    required this.timeExpired,
    required this.isPurchased,
    required this.isActive,
    required this.freeDays,
    required this.isFreeUser,
    required this.timeActive,
    this.profileTrial = 0,
  });

  factory PurchasedInfoModel.fromJson(Map<String, dynamic> json) {
    return PurchasedInfoModel(
      isEnrolled: json['is_enroll'],
      timeExpired: json['time_expire'],
      isPurchased: json['is_purchased'],
      isActive: json['is_active'],
      freeDays: json['free_days'],
      isFreeUser: json['free_user'],
      timeActive: json['time_active'],
      profileTrial: json['profile_trial'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_enroll': isEnrolled,
      'time_expired': timeExpired,
      'is_purchased': isPurchased,
      'is_active': isActive,
      'free_days': freeDays,
      'free_user': isFreeUser,
      'time_active': timeActive,
      'profile_trial': profileTrial,
    };
  }

  PurchasedInfoEntity toEntity() {
    return PurchasedInfoEntity(
      isEnrolled: isEnrolled,
      timeExpired: timeExpired,
      isPurchased: isPurchased,
      isActive: isActive,
      freeDays: freeDays,
      isFreeUser: isFreeUser,
      timeActive: timeActive,
      profileTrial: profileTrial,
    );
  }
}
