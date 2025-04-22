import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/domain/entities/account/user_entity.dart';
import 'package:monkey_stories/domain/usecases/account/get_load_update.dart';
import 'package:monkey_stories/domain/usecases/auth/logout_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';

part 'user_state.dart';

final logger = Logger('AuthenticationCubit');

class UserCubit extends Cubit<UserState> {
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

  void _clearUser() {
    emit(state.copyWith(user: null));
  }

  Future<void> logout() async {
    final result = await _logoutUsecase.call(null);
    if (result.isRight()) {
      _clearUser();
      _profileCubit.clearProfile();
    }
  }

  Future<void> loadUpdate() async {
    final result = await _getLoadUpdateUsecase.call(null);

    result.fold(
      (failure) {
        return;
      },
      (loadUpdate) {
        updateUser(loadUpdate!.user);
      },
    );
  }
}
