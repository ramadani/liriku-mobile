import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class Checking extends AuthState {
  @override
  String toString() => 'Checking';
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'Unauthenticated';
}

class Authenticated extends AuthState {
  @override
  String toString() => 'Authenticated';
}

class AuthError extends AuthState {
  @override
  String toString() => 'AuthError';
}
