abstract class AuthDataProvider {
  Future<bool> setToken(String token);

  Future<String> getToken();
}
