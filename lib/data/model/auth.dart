import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String deviceName;
  final String token;
  final DateTime createdAt;

  Auth({this.deviceName, this.token, this.createdAt})
      : super([deviceName, token, createdAt]);
}
