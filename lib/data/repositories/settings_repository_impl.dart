import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/data/datasources/settings/settings_remote_data_source.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final SettingsRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  SettingsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, String>> getLanguage() async {
    try {
      final language = await localDataSource.getLanguage();
      if (language != null) {
        return Right(language);
      } else {
        return const Left(CacheFailure(message: 'Language not found'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveLanguage(String languageCode) async {
    try {
      final isLoggedIn = await authLocalDataSource.isLoggedIn();
      if (!isLoggedIn) {
        return const Right(null);
      }

      final response = await remoteDataSource.updateUserSetting(
        languageId: languageCode,
      );
      if (response.status == ApiStatus.success) {
        await localDataSource.saveLanguage(languageCode);
        return const Right(null); // Right(null) for void return type
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ThemeMode>> getTheme() async {
    try {
      final themeMode = await localDataSource.getTheme();
      return Right(themeMode);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme(ThemeMode themeMode) async {
    try {
      await localDataSource.saveTheme(themeMode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> getBackgroundMusic() async {
    try {
      final isEnabled = await localDataSource.getBackgroundMusic();
      return Right(isEnabled);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveBackgroundMusic(bool isEnabled) async {
    try {
      final response = await remoteDataSource.updateUserSetting(
        isBackgroundMusicEnabled: isEnabled,
      );

      if (response.status == ApiStatus.success) {
        await localDataSource.saveBackgroundMusic(isEnabled);
        return const Right(null);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
