import 'package:firebase_analytics/firebase_analytics.dart';

abstract class TrackingRemoteDataSource {
  Future<void> firebaseLogEvent(
    String eventName,
    Map<String, Object>? eventData,
  );
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final FirebaseAnalytics _firebaseAnalytics;

  TrackingRemoteDataSourceImpl({required FirebaseAnalytics firebaseAnalytics})
    : _firebaseAnalytics = firebaseAnalytics;

  @override
  Future<void> firebaseLogEvent(
    String eventName,
    Map<String, Object>? eventData,
  ) async {
    await _firebaseAnalytics.logEvent(name: eventName, parameters: eventData);
  }
}
