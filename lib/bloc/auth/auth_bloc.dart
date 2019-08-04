import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/bloc/auth/auth_events.dart';
import 'package:liriku/bloc/auth/auth_states.dart';
import 'package:liriku/bloc/auth/bloc.dart';
import 'package:liriku/data/provider/app_data_provider.dart';
import 'package:liriku/data/repository/artist_repository.dart';
import 'package:liriku/data/repository/auth_repository.dart';
import 'package:liriku/data/repository/collection_repository.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppDataProvider _appDataProvider;
  final AuthRepository _authRepository;
  final ArtistRepository _artistRepository;
  final LyricRepository _lyricRepository;
  final CollectionRepository _collectionRepository;

  AuthBloc(
    this._appDataProvider,
    this._authRepository,
    this._artistRepository,
    this._lyricRepository,
    this._collectionRepository,
  );

  @override
  AuthState get initialState => Checking();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    try {
      if (event is Check) {
        final isAuth = await _authRepository.check();
        if (isAuth) {
          await _syncTopRated();
          await _syncCollection();
          yield Authenticated();
        } else {
          dispatch(Login());
          yield Unauthenticated();
        }
      } else if (event is Login) {
        String deviceName = '';

        try {
          final deviceInfo = DeviceInfoPlugin();
          final androidInfo = await deviceInfo.androidInfo;
          deviceName = '${androidInfo.brand} - ${androidInfo.model}';
        } catch (e) {
          deviceName = 'Unknown';
        }

        await _authRepository.login(deviceName);
        dispatch(Check());
      }
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield AuthError();
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

  Future<void> _syncCollection() async {
    final shouldSync = await _appDataProvider.shouldSyncCollection();
    final needSync = await _collectionRepository.needSync();

    if (shouldSync || needSync) {
      await _collectionRepository.sync();
      await _appDataProvider.setLastSyncCollection();
    }
  }
}
