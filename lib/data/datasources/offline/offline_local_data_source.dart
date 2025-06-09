abstract class OfflineLocalDataSource {
  Future<void> setLastOnlineTime();
  Future<int?> getLastOnlineTime();
}
