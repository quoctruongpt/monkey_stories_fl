import 'package:monkey_stories/data/datasources/kinesis/kinesis_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/notification/notification_remote_data_soure.dart';
import 'package:monkey_stories/data/datasources/airbridge/airbridge_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/tracking/tracking_local_data_source.dart';
import 'package:monkey_stories/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final AirbridgeRemoteDataSource _airbridgeRemoteDataSource;
  final NotificationRemoteDataSource _notificationRemoteDataSource;
  final TrackingLocalDataSource _trackingLocalDataSource;
  final KinesisRemoteDataSource _kinesisRemoteDataSource;

  TrackingRepositoryImpl({
    required AirbridgeRemoteDataSource airbridgeRemoteDataSource,
    required NotificationRemoteDataSource notificationRemoteDataSource,
    required TrackingLocalDataSource trackingLocalDataSource,
    required KinesisRemoteDataSource kinesisRemoteDataSource,
  }) : _airbridgeRemoteDataSource = airbridgeRemoteDataSource,
       _notificationRemoteDataSource = notificationRemoteDataSource,
       _trackingLocalDataSource = trackingLocalDataSource,
       _kinesisRemoteDataSource = kinesisRemoteDataSource;

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

  @override
  Future<void> pushEvent({
    required String eventName,
    Map<String, dynamic>? semanticProperties,
    Map<String, dynamic>? customProperties,
    bool isPushAirbridge = false,
    bool isPushKinesis = true,
  }) async {
    final defaultProperties =
        await _trackingLocalDataSource.getDefaultProperties();
    String partitionKey = '';
    if (defaultProperties.profileId != null) {
      partitionKey = defaultProperties.profileId.toString();
    } else if (defaultProperties.userId != null) {
      partitionKey = defaultProperties.userId.toString();
    } else {
      final deviceId = await _airbridgeRemoteDataSource.getDeviceId();
      partitionKey = deviceId;
    }

    if (isPushAirbridge) {
      _airbridgeRemoteDataSource.pushEvent(
        eventName,
        semanticProperties,
        customProperties,
      );
    }

    if (isPushKinesis) {
      await _kinesisRemoteDataSource.pushEvent(partitionKey, {
        'event_name': eventName,
        'time_record': DateTime.now().toIso8601String(),
        'properties': {
          ...(semanticProperties ?? {}),
          ...(customProperties ?? {}),
        },
      });
    }
  }
}
