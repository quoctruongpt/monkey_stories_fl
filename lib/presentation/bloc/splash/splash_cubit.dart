import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
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

  final Logger _logger = Logger('SplashCubit');

  SplashCubit({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required RegisterDeviceUseCase registerDeviceUseCase,
    required AppCubit appCubit, // Inject AppCubit
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _registerDeviceUseCase = registerDeviceUseCase,
       _appCubit = appCubit, // Gán AppCubit
       super(SplashInitial());

  Future<void> initializeApp() async {
    emit(SplashLoading());
    try {
      // 1. Ensure device is registered
      final deviceResult = await _registerDeviceUseCase.call(NoParams());

      // Xử lý kết quả đăng ký device
      deviceResult.fold(
        (failure) {
          // Lỗi khi đăng ký device, có thể log hoặc emit lỗi cụ thể
          _logger.warning(
            'Failed to register device during splash: ${failure.displayMessage}',
          );
          // Quyết định: có nên dừng lại hay tiếp tục kiểm tra auth?
          // Ví dụ: nếu không có device ID thì không thể tiếp tục -> emit Error
          // emit(SplashError('Device registration failed: ${failure.displayMessage}'));
          // Hoặc có thể tiếp tục nếu device ID không bắt buộc ngay lập tức
        },
        (deviceId) {
          // Đăng ký thành công, cập nhật AppCubit
          _logger.info('Device registered/retrieved successfully: $deviceId');
          _appCubit.updateDeviceInfo(
            deviceId: deviceId,
          ); // Gọi phương thức của AppCubit
        },
      );

      // Nếu lỗi đăng ký device không nghiêm trọng và muốn tiếp tục:
      // 2. Check authentication status
      final authResult = await _checkAuthStatusUseCase.call(NoParams());

      authResult.fold(
        (failure) {
          _logger.warning(
            'Failed to check auth status during splash: ${failure.displayMessage}',
          );
          // Nếu không kiểm tra được auth, thường là nên đưa về màn hình đăng nhập
          emit(
            SplashError(
              'Auth check failed: ${failure.displayMessage}. Please login again.',
            ),
          );
          // Hoặc emit(SplashUnauthenticated());
        },
        (isLoggedIn) {
          if (isLoggedIn) {
            _logger.info('User is logged in.');
            emit(SplashAuthenticated());
          } else {
            _logger.info('User is not logged in.');
            emit(SplashUnauthenticated());
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.severe(
        'Unexpected error during splash initialization',
        e,
        stackTrace,
      );
      emit(SplashError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
