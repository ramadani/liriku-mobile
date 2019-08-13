import 'package:liriku/data/model/auth.dart';
import 'package:liriku/data/provider/app_data_provider.dart';
import 'package:liriku/data/provider/auth_provider.dart';
import 'package:liriku/data/repository/auth_repository.dart';

class AuthRepositoryConcrete implements AuthRepository {
  final AuthProvider _authProvider;
  final AppDataProvider _authDataProvider;

  AuthRepositoryConcrete(this._authProvider, this._authDataProvider);

  @override
  Future<Auth> login(String deviceName) async {
    final data = await _authProvider.create(deviceName);
    await _authDataProvider.setToken(data.token);

    return data;
  }

  @override
  Future<bool> check() async {
    final token = await _authDataProvider.getToken();

    return token != null;
  }
}
