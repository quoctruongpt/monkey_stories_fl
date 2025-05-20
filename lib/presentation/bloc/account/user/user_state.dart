part of 'user_cubit.dart';

class UserState extends Equatable {
  // Thông tin người dùng
  final UserEntity? user;

  // Thông tin mua sản phẩm
  final PurchasedInfoEntity? purchasedInfo;

  // Thông tin cài đặt profiles
  final SyncUserProfilesEntity? syncUserProfiles;

  // Đang trong luồng đi gán thông tin khi đã mua sản phẩm
  final bool isPurchasing;

  const UserState({
    this.user,
    this.purchasedInfo,
    this.syncUserProfiles,
    this.isPurchasing = false,
  });

  UserState copyWith({
    UserEntity? user,
    PurchasedInfoEntity? purchasedInfo,
    SyncUserProfilesEntity? syncUserProfiles,
    bool? isClear,
    bool? isPurchasing,
  }) {
    return UserState(
      user: isClear == true ? null : user ?? this.user,
      purchasedInfo:
          isClear == true ? null : purchasedInfo ?? this.purchasedInfo,
      syncUserProfiles:
          isClear == true ? null : syncUserProfiles ?? this.syncUserProfiles,
      isPurchasing: isPurchasing ?? this.isPurchasing,
    );
  }

  @override
  List<Object?> get props => [
    user,
    purchasedInfo,
    isPurchasing,
    syncUserProfiles,
  ];

  UserState fromJson(Map<String, dynamic> json) {
    return UserState(
      user: UserEntity.fromJson(json['user']),
      purchasedInfo: PurchasedInfoEntity.fromJson(json['purchasedInfo']),
      syncUserProfiles: SyncUserProfilesEntity.fromJson(
        json['syncUserProfiles'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'purchasedInfo': purchasedInfo?.toJson(),
      'syncUserProfiles': syncUserProfiles?.toJson(),
    };
  }
}
