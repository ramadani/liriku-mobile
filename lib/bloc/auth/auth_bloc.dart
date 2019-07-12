import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:liriku/bloc/auth/auth_events.dart';
import 'package:liriku/bloc/auth/auth_states.dart';
import 'package:liriku/data/provider/app_data_provider.dart';
import 'package:liriku/data/repository/artist_repository.dart';
import 'package:liriku/data/repository/auth_repository.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppDataProvider _appDataProvider;
  final AuthRepository _authRepository;
  final ArtistRepository _artistRepository;
  final LyricRepository _lyricRepository;

  AuthBloc(this._appDataProvider,
      this._authRepository,
      this._artistRepository,
      this._lyricRepository,);

  @override
  AuthState get initialState => Checking();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is Check) {
      final isAuth = await _authRepository.check();
      if (isAuth) {
        await _syncTopRated();
        yield Authenticated();
      } else {
        dispatch(Login());
        yield Unauthenticated();
      }
    } else if (event is Login) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      await _authRepository.login(androidInfo.model);
      await _syncTopRated();
      yield Authenticated();
    }
  }

  Future<void> _syncTopRated() async {
    final shouldSync = await _appDataProvider.shouldSyncTopRated();

    if (shouldSync) {
      await _artistRepository.syncTopArtist();
      await _lyricRepository.syncTopLyric();
      await _appDataProvider.setLastSyncTopRated();
    }
  }
}
