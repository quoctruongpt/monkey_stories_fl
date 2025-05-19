import 'package:monkey_stories/domain/entities/account/purchased_info_entity.dart';
import 'package:monkey_stories/domain/entities/account/sync_user_entity.dart';
import 'package:monkey_stories/domain/entities/account/user_entity.dart';

class LoadUpdateEntity {
  final UserEntity user;
  final PurchasedInfoEntity purchasedInfo;
  final SyncUserEntity syncUser;

  LoadUpdateEntity({
    required this.user,
    required this.purchasedInfo,
    required this.syncUser,
  });
}
