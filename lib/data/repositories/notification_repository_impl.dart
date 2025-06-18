import 'package:monkey_stories/domain/repositories/notification_repository.dart';
import 'package:monkey_stories/data/datasources/notification/notification_remote_data_soure.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _notificationRemoteDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource notificationRemoteDataSource,
  }) : _notificationRemoteDataSource = notificationRemoteDataSource;

  @override
  Future<void> saveFcmToken() async {
    final token = await _notificationRemoteDataSource.getFcmToken();
    if (token == null) {
      throw Exception('FCM token is null');
    }
    await _notificationRemoteDataSource.saveFcmToken(token);
  }
}
