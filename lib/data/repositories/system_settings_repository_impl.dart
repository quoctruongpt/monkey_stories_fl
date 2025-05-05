import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/system/system_settings_data_source.dart';
import 'package:monkey_stories/domain/repositories/system_settings_repository.dart';

class SystemSettingsRepositoryImpl implements SystemSettingsRepository {
  final SystemSettingsDataSource dataSource;

  SystemSettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) async {
    try {
      await dataSource.setPreferredOrientations(orientations);
      return const Right(null);
    } on SystemException catch (e) {
      // Chuyển SystemException thành một loại Failure phù hợp (ví dụ: SystemFailure)
      return Left(SystemFailure(message: e.message));
    } catch (e) {
      return Left(
        SystemFailure(
          message: 'Unexpected error setting orientations: ${e.toString()}',
        ),
      );
    }
  }
}

// Định nghĩa SystemFailure nếu chưa có trong core/error/failures.dart
class SystemFailure extends Failure {
  final String message;
  const SystemFailure({this.message = 'System Failure'});

  @override
  List<Object> get props => [message];
}
