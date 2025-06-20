abstract class TrackingRepository {
  Future<void> registerToken();
  Future<void> setUserInfo({
    required String userId,
    String? email,
    String? phone,
    String? name,
    bool? isPaid,
    bool? isAuthenticated,
  });
  Future<void> pushEvent({
    required String eventName,
    Map<String, dynamic>? semanticProperties,
    Map<String, dynamic>? customProperties,
    bool isPushAirbridge = true,
    bool isPushKinesis = false,
  });
}
