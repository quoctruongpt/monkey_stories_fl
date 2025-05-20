import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/domain/entities/account/purchased_info_entity.dart';
import 'package:monkey_stories/domain/entities/account/sync_user_entity.dart';
import 'package:monkey_stories/domain/entities/account/user_entity.dart';
import 'package:monkey_stories/domain/usecases/account/get_load_update.dart';
import 'package:monkey_stories/domain/usecases/auth/logout_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';

part 'user_state.dart';

final logger = Logger('UserCubit');

class UserCubit extends HydratedCubit<UserState> {
  final LogoutUsecase _logoutUsecase;
  final GetLoadUpdateUsecase _getLoadUpdateUsecase;
  final ProfileCubit _profileCubit;
  final AppCubit _appCubit;
  // Khởi tạo với trạng thái ban đầu
  UserCubit({
    required LogoutUsecase logoutUsecase,
    required GetLoadUpdateUsecase getLoadUpdateUsecase,
    required ProfileCubit profileCubit,
    required AppCubit appCubit,
  }) : _logoutUsecase = logoutUsecase,
       _getLoadUpdateUsecase = getLoadUpdateUsecase,
       _profileCubit = profileCubit,
       _appCubit = appCubit,
       super(const UserState());

  void updateUser(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  void updatePurchasedInfo(PurchasedInfoEntity purchasedInfo) {
    emit(state.copyWith(purchasedInfo: purchasedInfo));
  }

  void updateSyncUserProfiles(SyncUserProfilesEntity syncUserProfiles) {
    emit(state.copyWith(syncUserProfiles: syncUserProfiles));
  }

  SyncUserProfileEntity? getSettingProfile(int id) {
    return state.syncUserProfiles?.profiles.firstWhereOrNull(
      (element) => element.id == id,
    );
  }

  void updateNumberChangeAge(int id, int numberChangeAge) {
    final profiles =
        state.syncUserProfiles?.profiles
            .map(
              (e) =>
                  e.id == id ? e.copyWith(numberChangeAge: numberChangeAge) : e,
            )
            .toList();
    emit(
      state.copyWith(
        syncUserProfiles: state.syncUserProfiles?.copyWith(profiles: profiles),
      ),
    );
  }

  void _clear() {
    emit(state.copyWith(isClear: true));
  }

  Future<void> logout() async {
    final result = await _logoutUsecase.call(null);
    if (result.isRight()) {
      _clear();
      _profileCubit.clearProfile();
    }
  }

  Future<void> loadUpdate() async {
    try {
      final result = await _getLoadUpdateUsecase.call(null);

      result.fold(
        (failure) {
          return;
        },
        (loadUpdate) {
          updateUser(loadUpdate!.user);
          updatePurchasedInfo(loadUpdate.purchasedInfo);
          updateSyncUserProfiles(loadUpdate.syncUser.profiles!);
          _appCubit.loadInitialSettings();
        },
      );
    } catch (e) {
      logger.severe('Error loading update $e');
    }
  }

  void togglePurchasing() {
    emit(state.copyWith(isPurchasing: !state.isPurchasing));
  }

  @override
  UserState fromJson(Map<String, dynamic> json) {
    return state.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(UserState state) {
    return state.toJson();
  }
}
