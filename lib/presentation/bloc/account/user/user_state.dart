part of 'user_cubit.dart';

class UserState extends Equatable {
  // Thông tin người dùng
  final UserEntity? user;

  // Thông tin mua sản phẩm
  final PurchasedInfoEntity? purchasedInfo;

  // Đang trong luồng đi gán thông tin khi đã mua sản phẩm
  final bool isPurchasing;

  const UserState({this.user, this.purchasedInfo, this.isPurchasing = false});

  UserState copyWith({
    UserEntity? user,
    PurchasedInfoEntity? purchasedInfo,
    bool? isClear,
    bool? isPurchasing,
  }) {
    return UserState(
      user: isClear == true ? null : user ?? this.user,
      purchasedInfo:
          isClear == true ? null : purchasedInfo ?? this.purchasedInfo,
      isPurchasing: isPurchasing ?? this.isPurchasing,
    );
  }

  @override
  List<Object?> get props => [user, purchasedInfo, isPurchasing];

  UserState fromJson(Map<String, dynamic> json) {
    return UserState(
      user: UserEntity.fromJson(json['user']),
      purchasedInfo: PurchasedInfoEntity.fromJson(json['purchasedInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'purchasedInfo': purchasedInfo?.toJson()};
  }
}
