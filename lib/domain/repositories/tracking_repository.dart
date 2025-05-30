abstract class TrackingRepository {
  Future<void> registerToken();
  Future<void> setUserInfo({
    required String userId,
    String? email,
    String? phone,
    String? name,
  });
  Future<void> pushEvent({
    required String eventName,
    Map<String, dynamic>? semanticProperties,
    Map<String, dynamic>? customProperties,
    bool isPushAirbridge = false,
    bool isPushKinesis = true,
  });
}
