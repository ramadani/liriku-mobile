import 'package:liriku/data/provider/auth_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDataProviderPrefs implements AuthDataProvider {
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
}
