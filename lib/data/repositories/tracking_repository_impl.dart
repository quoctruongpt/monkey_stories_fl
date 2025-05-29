import 'package:monkey_stories/data/datasources/notification/notification_remote_data_soure.dart';
import 'package:monkey_stories/data/datasources/tracking/tracking_remote_data_source.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource _trackingRemoteDataSource;
  final NotificationRemoteDataSource _notificationRemoteDataSource;

  TrackingRepositoryImpl({
    required TrackingRemoteDataSource trackingRemoteDataSource,
    required NotificationRemoteDataSource notificationRemoteDataSource,
  }) : _trackingRemoteDataSource = trackingRemoteDataSource,
       _notificationRemoteDataSource = notificationRemoteDataSource;

  @override
  Future<void> registerTokenAirbridge() async {
    final token = await _notificationRemoteDataSource.getFcmToken();
    if (token != null) {
      await _trackingRemoteDataSource.registerTokenAirbridge(token);
    }
  }
}
