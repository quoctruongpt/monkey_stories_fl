import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';
import 'package:monkey_stories/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

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
      await localDataSource.saveLanguage(languageCode);
      return const Right(null); // Right(null) for void return type
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
}
