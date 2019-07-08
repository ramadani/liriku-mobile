import 'package:liriku/data/provider/auth_provider.dart';
import 'package:liriku/data/repository/auth_repository.dart';

class AuthRepositoryConcrete implements AuthRepository {
  final AuthProvider _authProvider;

  AuthRepositoryConcrete(this._authProvider);

  @override
  Future<String> login(String deviceName) async {
    final data = await _authProvider.create(deviceName);
    return data.token;
  }
}
