import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/models/auth/user.dart';

part 'user_state.dart';

final logger = Logger('AuthenticationCubit');

class UserCubit extends Cubit<UserState> {
  // Khởi tạo với trạng thái ban đầu
  UserCubit() : super(const UserState());

  void updateUser(User user) {
    emit(state.copyWith(user: user));
  }

  void clearUser() {
    emit(state.copyWith(user: null));
  }
}
