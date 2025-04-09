import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/shared_pref_keys.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/models/auth/login_data.dart';
import 'package:monkey_stories/models/auth/user.dart';
import 'package:monkey_stories/services/api/auth_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

final logger = Logger('AuthenticationCubit');

class AuthenticationCubit extends Cubit<AuthState> {
  // Khởi tạo với trạng thái ban đầu
  AuthenticationCubit() : super(const AuthState(isAuthenticated: false)) {
    _checkAuthenticationStatus();
  }

  // Hàm kiểm tra trạng thái đăng nhập khi khởi động app (ví dụ)
  Future<void> _checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(SharedPrefKeys.token);

    emit(state.copyWith(isAuthenticated: token != null));
  }

  Future<void> logInWithPhone({
    required String phone,
    required String password,
  }) async {
    try {
      emit(state.copyWith(error: null));
      final response = await AuthApiService().login(
        LoginRequestData(
          phone: phone,
          password: password,
          loginType: LoginType.phone,
        ),
      );

      if (response.status == ApiStatus.success && response.data != null) {
        final loginData = response.data!;
        final user = User(id: loginData.userId);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(SharedPrefKeys.token, loginData.accessToken);
        await prefs.setString(
          SharedPrefKeys.refreshToken,
          loginData.refreshToken,
        );

        emit(state.copyWith(user: user, isAuthenticated: true, error: null));
        return;
      }

      emit(
        state.copyWith(
          error: AuthError(message: response.message, code: response.code),
          isAuthenticated: false,
        ),
      );
    } catch (e) {
      logger.severe('Error logging in: $e');
      emit(
        state.copyWith(
          error: AuthError(
            code: 500,
            message: 'Lỗi đăng nhập: ${e.toString()}',
          ),
        ),
      );
    }
  }

  Future<void> signUp(/* Tham số cần thiết cho đăng ký */) async {}

  Future<void> requestPasswordReset({required String email}) async {}

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefKeys.token);
    await prefs.remove(SharedPrefKeys.refreshToken);
    emit(state.copyWith(user: null, isAuthenticated: false, error: null));
  }
}
