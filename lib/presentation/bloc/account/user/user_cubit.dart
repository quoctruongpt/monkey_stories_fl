import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/domain/entities/account/purchased_info_entity.dart';
import 'package:monkey_stories/domain/entities/account/user_entity.dart';
import 'package:monkey_stories/domain/usecases/account/get_load_update.dart';
import 'package:monkey_stories/domain/usecases/auth/logout_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';

part 'user_state.dart';

final logger = Logger('UserCubit');

class UserCubit extends HydratedCubit<UserState> {
  final LogoutUsecase _logoutUsecase;
  final GetLoadUpdateUsecase _getLoadUpdateUsecase;
  final ProfileCubit _profileCubit;
  // Khởi tạo với trạng thái ban đầu
  UserCubit({
    required LogoutUsecase logoutUsecase,
    required GetLoadUpdateUsecase getLoadUpdateUsecase,
    required ProfileCubit profileCubit,
  }) : _logoutUsecase = logoutUsecase,
       _getLoadUpdateUsecase = getLoadUpdateUsecase,
       _profileCubit = profileCubit,
       super(const UserState());

  void updateUser(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  void updatePurchasedInfo(PurchasedInfoEntity purchasedInfo) {
    emit(state.copyWith(purchasedInfo: purchasedInfo));
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
