import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/auth/auth_events.dart';
import 'package:liriku/bloc/auth/auth_states.dart';
import 'package:liriku/data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository);

  @override
  AuthState get initialState => Checking();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is Check) {
      yield Unauthenticated();
    } else if (event is Login) {
      await _repository.login('SAMSUNG GALAXI 3000');

      yield Authenticated();
    }
  }
}
