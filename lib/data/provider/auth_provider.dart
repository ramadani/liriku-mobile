import 'package:liriku/data/model/auth.dart';

abstract class AuthProvider {
  Future<Auth> create(String deviceName);
}
