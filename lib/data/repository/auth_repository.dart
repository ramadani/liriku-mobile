import 'package:liriku/data/model/auth.dart';

abstract class AuthRepository {
  Future<Auth> login(String deviceName);

  Future<bool> check();
}
