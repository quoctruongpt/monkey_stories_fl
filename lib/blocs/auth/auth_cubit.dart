import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/models/auth/user.dart';

part 'auth_state.dart';

final logger = Logger('AuthenticationCubit');

class AuthenticationCubit extends Cubit<AuthState> {
  // Khởi tạo với trạng thái ban đầu
  AuthenticationCubit() : super(const AuthState());

  void saveUser(User user) {
    emit(state.copyWith(user: user));
  }

  void clearUser() {
    emit(state.copyWith(user: null));
  }
}
