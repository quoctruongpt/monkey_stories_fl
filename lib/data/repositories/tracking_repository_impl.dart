import 'package:monkey_stories/data/datasources/notification/notification_remote_data_soure.dart';
import 'package:monkey_stories/data/datasources/airbridge/airbridge_remote_data_source.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final AirbridgeRemoteDataSource _airbridgeRemoteDataSource;
  final NotificationRemoteDataSource _notificationRemoteDataSource;

  TrackingRepositoryImpl({
    required AirbridgeRemoteDataSource airbridgeRemoteDataSource,
    required NotificationRemoteDataSource notificationRemoteDataSource,
  }) : _airbridgeRemoteDataSource = airbridgeRemoteDataSource,
       _notificationRemoteDataSource = notificationRemoteDataSource;

  @override
  Future<void> registerToken() async {
    final token = await _notificationRemoteDataSource.getFcmToken();
    if (token != null) {
      await _airbridgeRemoteDataSource.registerTokenAirbridge(token);
    }
  }

  @override
  Future<void> setUserInfo({
    required String userId,
    String? email,
    String? phone,
    String? name,
  }) async {
    await _airbridgeRemoteDataSource.setUserInfo(userId, email, phone, name);
  }
}
