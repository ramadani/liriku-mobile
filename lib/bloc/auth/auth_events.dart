import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class Login extends AuthEvent {
  @override
  String toString() => 'Login';
}

class Check extends AuthEvent {
  @override
  String toString() => 'AuthCheck';
}
