abstract class TrackingRepository {
  Future<void> registerToken();
  Future<void> setUserInfo({
    required String userId,
    String? email,
    String? phone,
    String? name,
  });
}
