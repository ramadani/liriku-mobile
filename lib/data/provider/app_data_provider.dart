abstract class AppDataProvider {
  Future<bool> setToken(String token);

  Future<String> getToken();

  Future<bool> setLastSyncTopRated();

  Future<bool> shouldSyncTopRated();

  Future<bool> setLastSyncCollection();

  Future<bool> shouldSyncCollection();
}
