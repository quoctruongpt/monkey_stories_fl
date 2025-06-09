import 'package:monkey_stories/data/datasources/offline/offline_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _lastOnlineTimeKey = 'last_online_time';

class OfflineLocalDataSourceImpl implements OfflineLocalDataSource {
  final SharedPreferences sharedPreferences;

  OfflineLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<int?> getLastOnlineTime() async {
    return sharedPreferences.getInt(_lastOnlineTimeKey);
  }

  @override
  Future<void> setLastOnlineTime() async {
    await sharedPreferences.setInt(
      _lastOnlineTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
