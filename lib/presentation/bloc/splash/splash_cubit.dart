import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/core/error/failures.dart';

// Assume these UseCases exist and are imported correctly
import 'package:monkey_stories/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:monkey_stories/domain/usecases/device/register_device_usecase.dart'; // Assuming this exists
import 'package:monkey_stories/core/usecases/usecase.dart';

import 'package:monkey_stories/presentation/bloc/splash/splash_state.dart'; // Sử dụng package import

class SplashCubit extends Cubit<SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final RegisterDeviceUseCase _registerDeviceUseCase; // Assuming this exists
  final AppCubit _appCubit; // Thêm dependency AppCubit
  final UserCubit _userCubit; // Thêm dependency UserCubit

  final Logger _logger = Logger('SplashCubit');
  final int _splashTime = 3;

  SplashCubit({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required RegisterDeviceUseCase registerDeviceUseCase,
    required AppCubit appCubit, // Inject AppCubit
    required UserCubit userCubit, // Inject UserCubit
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _registerDeviceUseCase = registerDeviceUseCase,
       _appCubit = appCubit, // Gán AppCubit
       _userCubit = userCubit, // Gán UserCubit
       super(SplashInitial());

  Future<void> initializeApp() async {
    emit(SplashLoading());
    final startTime = DateTime.now(); // Ghi lại thời gian bắt đầu

    try {
      // 1. Ensure device is registered
      final deviceResult = await _registerDeviceUseCase.call(NoParams());

      // Xử lý kết quả đăng ký device. Nếu lỗi, dừng ngay.
      // Nếu thành công, tiếp tục kiểm tra auth.
      await deviceResult.fold(
        (failure) async {
          // Lỗi đăng ký device
          _logger.warning(
            'Failed to register device during splash: ${failure.displayMessage}',
          );
          final errorState = SplashError(
            'Device registration failed: ${failure.displayMessage}',
          );

          emit(errorState); // Phát trạng thái lỗi và dừng
          // Không cần return vì đây là nhánh cuối cùng của fold trong trường hợp lỗi
        },
        (deviceId) async {
          // Đăng ký device thành công
          _logger.info('Device registered/retrieved successfully: $deviceId');
          _appCubit.updateDeviceInfo(deviceId: deviceId); // Cập nhật AppCubit

          // Chỉ tiếp tục kiểm tra auth nếu đăng ký device thành công
          // 2. Check authentication status
          final authResult = await _checkAuthStatusUseCase.call(NoParams());
          SplashState finalState; // Biến để giữ trạng thái cuối cùng sau auth

          finalState = await authResult.fold(
            (authFailure) {
              _logger.warning(
                'Failed to check auth status during splash: ${authFailure.displayMessage}',
              );
              return SplashError(
                'Auth check failed: ${authFailure.displayMessage}. Please login again.',
              );
            },
            (isLoggedIn) {
              if (isLoggedIn) {
                _logger.info('User is logged in.');
                return _handleLogicAuthenticated();
              } else {
                _logger.info('User is not logged in.');
                return _handleLogicUnauthenticated();
              }
            },
          );

          // Đảm bảo hiển thị màn hình splash đủ thời gian
          final endTime = DateTime.now();
          final duration = endTime.difference(startTime);
          final remainingTime = Duration(seconds: _splashTime) - duration;
          if (remainingTime > Duration.zero) {
            await Future.delayed(remainingTime);
          }

          emit(finalState); // Phát trạng thái cuối cùng
        },
      );
    } catch (e, stackTrace) {
      // Xử lý lỗi không mong muốn khác
      _logger.severe(
        'Unexpected error during splash initialization',
        e,
        stackTrace,
      );
      SplashState errorState = SplashError(
        'An unexpected error occurred: ${e.toString()}',
      );

      // Đảm bảo hiển thị màn hình splash đủ thời gian trước khi báo lỗi
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      final remainingTime = Duration(seconds: _splashTime) - duration;
      if (remainingTime > Duration.zero) {
        await Future.delayed(remainingTime);
      }
      emit(errorState);
    }
  }

  Future<SplashState> _handleLogicAuthenticated() async {
    await _userCubit.loadUpdate();
    return SplashAuthenticated();
  }

  Future<SplashState> _handleLogicUnauthenticated() async {
    return SplashUnauthenticated();
  }
}
