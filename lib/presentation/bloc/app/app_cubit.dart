import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'dart:ui';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/entities/unity/unity_payload_entity.dart';
import 'package:monkey_stories/domain/usecases/settings/get_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_language_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/get_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_sound_track_usecase.dart';
import 'package:monkey_stories/domain/usecases/settings/save_theme_usecase.dart';
import 'package:monkey_stories/domain/usecases/system/set_preferred_orientations_usecase.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:monkey_stories/domain/usecases/settings/get_sound_track_usecase.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final SaveSoundTrackUsecase _saveSoundTrackUsecase;
  final GetLanguageUseCase _getLanguageUseCase;
  final SaveLanguageUseCase _saveLanguageUseCase;
  final GetThemeUseCase _getThemeUseCase;
  final SaveThemeUseCase _saveThemeUseCase;
  final SetPreferredOrientationsUseCase _setPreferredOrientationsUseCase;
  final UnityCubit _unityCubit;
  final GetSoundTrackUseCase _getSoundTrackUseCase;
  final Logger _logger = Logger('AppCubit');

  AppCubit({
    required GetLanguageUseCase getLanguageUseCase,
    required SaveLanguageUseCase saveLanguageUseCase,
    required GetThemeUseCase getThemeUseCase,
    required SaveThemeUseCase saveThemeUseCase,
    required SetPreferredOrientationsUseCase setPreferredOrientationsUseCase,
    required UnityCubit unityCubit,
    required SaveSoundTrackUsecase saveSoundTrackUsecase,
    required GetSoundTrackUseCase getSoundTrackUseCase,
  }) : _getLanguageUseCase = getLanguageUseCase,
       _saveLanguageUseCase = saveLanguageUseCase,
       _getThemeUseCase = getThemeUseCase,
       _saveThemeUseCase = saveThemeUseCase,
       _setPreferredOrientationsUseCase = setPreferredOrientationsUseCase,
       _unityCubit = unityCubit,
       _saveSoundTrackUsecase = saveSoundTrackUsecase,
       _getSoundTrackUseCase = getSoundTrackUseCase,
       super(
         const AppState(
           isOrientationLoading: false,
           isDarkMode: false,
           languageCode: 'vi',
           appVersion: '...',
         ),
       ) {
    loadInitialSettings();
  }

  Future<void> loadInitialSettings() async {
    _logger.info('Loading initial settings...');
    final langResult = await _getLanguageUseCase.call(NoParams());
    final themeResult = await _getThemeUseCase.call(NoParams());
    final packageInfo = await PackageInfo.fromPlatform();
    final soundTrackResult = await _getSoundTrackUseCase.call(NoParams());

    String initialLanguage = Languages.defaultLanguage;
    bool initialIsDarkMode = false;
    bool initialIsSoundTrack = true;
    String appVersion = packageInfo.version;

    langResult.fold(
      (failure) {
        _logger.warning(
          'Failed to load saved language: ${failure.displayMessage}. Trying device language.',
        );
        final deviceLanguage = PlatformDispatcher.instance.locale.languageCode;
        if (Languages.supportedLanguages.any(
          (language) => language.code == deviceLanguage,
        )) {
          initialLanguage = deviceLanguage;
          _logger.info('Using device language: $deviceLanguage');
        } else {
          initialLanguage = Languages.defaultLanguage;
        }

        _saveLanguageUseCase.call(initialLanguage);
      },
      (languageCode) =>
          initialLanguage =
              languageCode.isEmpty ? Languages.defaultLanguage : languageCode,
    );

    themeResult.fold(
      (failure) =>
          _logger.warning('Failed to load theme: ${failure.displayMessage}'),
      (themeMode) => initialIsDarkMode = (themeMode == ThemeMode.dark),
    );

    soundTrackResult.fold(
      (failure) => _logger.warning(
        'Failed to load sound track: ${failure.displayMessage}',
      ),
      (soundTrack) => initialIsSoundTrack = soundTrack,
    );

    _logger.info(
      'Initial settings loaded: lang=$initialLanguage, isDarkMode=$initialIsDarkMode, version=$appVersion',
    );
    emit(
      state.copyWith(
        languageCode: initialLanguage,
        isDarkMode: initialIsDarkMode,
        appVersion: appVersion,
        isBackgroundMusicEnabled: initialIsSoundTrack,
      ),
    );
  }

  void showLoading() {
    emit(state.copyWith(isOrientationLoading: true));
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) emit(state.copyWith(isOrientationLoading: false));
    });
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      _logger.info('Changing language to: $languageCode');
      final result = await _saveLanguageUseCase.call(languageCode);
      result.fold(
        (failure) => _logger.severe(
          'Failed to save language: ${failure.displayMessage}',
        ),
        (_) => emit(state.copyWith(languageCode: languageCode)),
      );
    } catch (e) {
      _logger.severe('Failed to save language: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _logger.info('Toggling theme to: $newMode');
    final result = await _saveThemeUseCase.call(newMode);
    result.fold(
      (failure) =>
          _logger.severe('Failed to save theme: ${failure.displayMessage}'),
      (_) => emit(state.copyWith(isDarkMode: !state.isDarkMode)),
    );
  }

  Future<void> setOrientation(AppOrientation orientation) async {
    if (state.orientation == orientation) return;

    _logger.info('Setting orientation to $orientation');

    List<DeviceOrientation> deviceOrientations;
    switch (orientation) {
      case AppOrientation.portrait:
        deviceOrientations = [DeviceOrientation.portraitUp];
        break;
      case AppOrientation.landscapeLeft:
        deviceOrientations = [DeviceOrientation.landscapeLeft];
        break;
      case AppOrientation.landscapeRight:
        deviceOrientations = [DeviceOrientation.landscapeRight];
        break;
    }

    final result = await _setPreferredOrientationsUseCase.call(
      deviceOrientations,
    );

    result.fold(
      (failure) {
        _logger.severe('Failed to set orientation: ${failure.displayMessage}');
      },
      (_) {
        _logger.info('Orientation set successfully via SystemChrome.');
        if (Platform.isAndroid) {
          _sendOrientationToUnity(orientation);
        }
        emit(state.copyWith(orientation: orientation));
      },
    );
  }

  void _sendOrientationToUnity(AppOrientation orientation) {
    _logger.fine('Sending orientation lock message to Unity: $orientation');
    final UnityMessageEntity message = UnityMessageEntity(
      type: MessageTypes.orientation,
      payload: OrientationPayloadEntity(orientation: orientation).toMap(),
    );
    _unityCubit.sendMessageToUnity(message);
  }

  void updateDeviceInfo({String? deviceId}) {
    _logger.fine('Updating deviceId in AppState: $deviceId');
    emit(state.copyWith(deviceId: deviceId));
  }

  Future<void> toggleBackgroundMusic() async {
    final oldValue = state.isBackgroundMusicEnabled;
    try {
      emit(state.copyWith(isBackgroundMusicEnabled: !oldValue));
      final result = await _saveSoundTrackUsecase.call(!oldValue);
      result.fold((failure) {
        _logger.severe(
          'Failed to toggle background music: ${failure.displayMessage}',
        );
        emit(state.copyWith(isBackgroundMusicEnabled: oldValue));
      }, (_) {});
    } catch (e) {
      _logger.severe('Failed to toggle background music: $e');
      emit(state.copyWith(isBackgroundMusicEnabled: oldValue));
    }
  }

  void toggleNotification() {
    emit(state.copyWith(isNotificationEnabled: !state.isNotificationEnabled));
  }
}
