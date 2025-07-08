// Package imports:
import 'package:firebase_analytics/firebase_analytics.dart';

abstract class TrackingRemoteDataSource {
  Future<void> firebaseLogEvent(
    String eventName,
    Map<String, Object>? eventData,
  );

  Future<void> firebaseLogin(String userId);

  Future<void> firebaseSetUserProperty({
    String? name,
    bool? isPaid,
    bool? isAuthenticated,
    String? phone,
    String? email,
  });
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

  @override
  Future<void> firebaseLogin(String userId) async {
    await _firebaseAnalytics.setUserId(id: userId);
  }

  @override
  Future<void> firebaseSetUserProperty({
    String? name,
    bool? isPaid,
    bool? isAuthenticated,
    String? phone,
    String? email,
  }) async {
    await _firebaseAnalytics.setUserProperty(name: 'name', value: name);
    await _firebaseAnalytics.setUserProperty(
      name: 'isPaid',
      value: isPaid?.toString(),
    );
    await _firebaseAnalytics.setUserProperty(
      name: 'isAuthenticated',
      value: isAuthenticated?.toString(),
    );
  }
}
