import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
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
      final isAuth = await _repository.check();
      if (isAuth) {
        yield Authenticated();
      } else {
        dispatch(Login());
        yield Unauthenticated();
      }
    } else if (event is Login) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      await _repository.login(androidInfo.model);
      yield Authenticated();
    }
  }
}
