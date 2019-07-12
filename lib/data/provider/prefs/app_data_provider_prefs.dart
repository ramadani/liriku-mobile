import 'package:liriku/data/provider/app_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataProviderPrefs implements AppDataProvider {
  @override
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('AUTH_TOKEN');
    return token;
  }

  @override
  Future<bool> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('AUTH_TOKEN', token);
  }

  @override
  Future<bool> setLastSyncTopRated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(
        'LAST_SYNC_TOP_RATED', DateTime
        .now()
        .millisecondsSinceEpoch);
  }

  @override
  Future<bool> shouldSyncTopRated() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncMills = prefs.getInt('LAST_SYNC_TOP_RATED');
    if (lastSyncMills == null) {
      return true;
    }

    final DateTime lastSync =
    DateTime.fromMillisecondsSinceEpoch(lastSyncMills);
    final expiresAt = lastSync.add(Duration(hours: 12));
    final now = DateTime.now();

    return now.isAfter(expiresAt);
  }
}
