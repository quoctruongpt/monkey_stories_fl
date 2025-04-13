import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core1/constants/constants.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/app/app_cubit.dart';
import 'package:monkey_stories/services/api/location_api_service.dart';
import 'package:monkey_stories/core/constants/shared_pref_keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Logger _logger = Logger('SplashScreen');

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _loadDeviceId();

      if (mounted) {
        _routeScreen();
      }
    } catch (e, stackTrace) {
      _logger.severe('Error during app initialization', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Initialization failed. Please restart the app.'),
          ),
        );
      }
    }
  }

  Future<void> _routeScreen() async {
    final isLoggedIn = await context.read<AuthRepository>().isLoggedIn();
    if (isLoggedIn) {
      GoRouter.of(context).replace(AppRoutePaths.home);
    } else {
      GoRouter.of(context).replace(AppRoutePaths.login);
    }
  }

  Future<void> _loadDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final locationApiService = LocationApiService();
    final appCubit = context.read<AppCubit>();

    String? deviceId = prefs.getString(SharedPrefKeys.deviceId);
    _logger.info('Device ID: $deviceId');

    if (deviceId == null || deviceId.isEmpty) {
      _logger.info('Device not registered. Registering...');
      try {
        final response = await locationApiService.registerDeviceLocation();
        if (response.status == ApiStatus.success) {
          _logger.info('Response: ${response.status}');
          deviceId = response.data?.deviceId;
          await prefs.setString(SharedPrefKeys.deviceId, deviceId!);
          _logger.info('Device registered successfully. Device ID: $deviceId');
        } else {
          throw Exception(response.message);
        }
      } catch (e, stackTrace) {
        _logger.severe('Failed to register device', e, stackTrace);
        throw Exception(e);
      }
    } else {
      _logger.info('Device already registered. Device ID: $deviceId');
    }

    appCubit.updateDeviceInfo(deviceId: deviceId);
  }

  @override
  Widget build(BuildContext context) {
    // Basic splash screen UI
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Initializing...'),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return Text('Device ID: ${state.deviceId}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
