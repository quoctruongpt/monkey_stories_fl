import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/core/error/failures.dart';

// Assume these UseCases exist and are imported correctly
import 'package:monkey_stories/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:monkey_stories/domain/usecases/device/register_device_usecase.dart'; // Assuming this exists
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';

import 'package:monkey_stories/presentation/bloc/splash/splash_state.dart'; // Sử dụng package import

class SplashCubit extends Cubit<SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final RegisterDeviceUseCase _registerDeviceUseCase;
  final AppCubit _appCubit;
  final UserCubit _userCubit;
  final ProfileCubit _profileCubit;
  final PurchasedCubit _purchasedCubit;

  final Logger _logger = Logger('SplashCubit');
  final int _splashTime = 3;

  SplashCubit({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required RegisterDeviceUseCase registerDeviceUseCase,
    required AppCubit appCubit,
    required UserCubit userCubit,
    required ProfileCubit profileCubit,
    required PurchasedCubit purchasedCubit,
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _registerDeviceUseCase = registerDeviceUseCase,
       _appCubit = appCubit,
       _userCubit = userCubit,
       _profileCubit = profileCubit,
       _purchasedCubit = purchasedCubit,
       super(SplashInitial());

  Future<void> runApp() async {
    _initializeApp();
    await _purchasedCubit.initialPurchased();
    await _purchasedCubit.getProducts();
  }

  Future<void> _initializeApp() async {
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

          final errorState = SplashError(
            'Device registration failed: ${failure.displayMessage}',
          );

          emit(errorState); // Phát trạng thái lỗi và dừng
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
    await _profileCubit.getListProfile();

    final user = _userCubit.state.user;
    final purchasedInfo = _userCubit.state.purchasedInfo;

    if (user?.loginType == LoginType.skip && purchasedInfo?.isActive == true) {
      return SplashNeedCreateAccount();
    }

    return SplashAuthenticated();
  }

  Future<SplashState> _handleLogicUnauthenticated() async {
    return SplashUnauthenticated();
  }
}
