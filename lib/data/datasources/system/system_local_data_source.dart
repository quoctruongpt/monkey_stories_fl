// Dart imports:
import 'dart:io';

// Package imports:
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:monkey_stories/core/constants/constants.dart';

abstract class SystemLocalDataSource {
  Future<String> getCountryCode();
  Future<void> cacheCountryCode(String countryCode);
  Future<void> deleteDataFolder(String path);
}

class SystemLocalDataSourceImpl implements SystemLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Logger _logger = Logger('SystemLocalDataSource');

  SystemLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getCountryCode() async {
    return sharedPreferences.getString(SharedPrefKeys.countryCode) ?? '';
  }

  @override
  Future<void> cacheCountryCode(String countryCode) async {
    await sharedPreferences.setString(SharedPrefKeys.countryCode, countryCode);
  }

  @override
  Future<void> deleteDataFolder(String path) async {
    final dir = Directory(path);

    if (await dir.exists()) {
      final files = dir.listSync();

      for (var entity in files) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (e) {
          _logger.severe('Error deleting data folder: $e');
        }
      }

      _logger.info('Data folder deleted: $path');
    } else {
      _logger.severe('Data folder not found: $path');
    }
  }
}
