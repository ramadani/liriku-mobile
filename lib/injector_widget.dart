import 'package:flutter/material.dart';
import 'package:liriku/bloc/auth/auth_bloc.dart';
import 'package:liriku/bloc/home/bloc.dart' as home;
import 'package:liriku/config/json_config.dart';
import 'package:liriku/data/provider/api/artist_provider_api.dart';
import 'package:liriku/data/provider/api/auth_provider_api.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/api/lyric_provider_api.dart';
import 'package:liriku/data/provider/db/artist_cache_provider_db.dart';
import 'package:liriku/data/provider/db/lyric_cache_provider_db.dart';
import 'package:liriku/data/provider/db/sqlite_provider.dart';
import 'package:liriku/data/provider/db/top_rated_provider_db.dart';
import 'package:liriku/data/provider/prefs/auth_data_provider_prefs.dart';
import 'package:liriku/data/repository/artist_repository.dart';
import 'package:liriku/data/repository/auth_repository.dart';
import 'package:liriku/data/repository/concrete/artist_repository_concrete.dart';
import 'package:liriku/data/repository/concrete/auth_repository_concrete.dart';
import 'package:liriku/data/repository/concrete/lyric_repository_concrete.dart';
import 'package:liriku/data/repository/lyric_repository.dart';
import 'package:meta/meta.dart';

class InjectorWidget extends InheritedWidget {
  String _envFilename;
  AuthRepository _authRepository;
  ArtistRepository _artistRepository;
  LyricRepository _lyricRepository;

  AuthBloc _authBloc;
  home.ArtistBloc _homeArtistBloc;
  home.LyricBloc _homeLyricBloc;

  InjectorWidget({
    Key key,
    @required Widget child,
    @required String envFilename,
  })
      : assert(child != null),
        _envFilename = envFilename,
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
    as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  Future<void> init() async {
    final config = JsonConfig();
    await config.loadFromAssets(_envFilename);

    final configData = config.data();
    final db = await SQLiteProvider().open();

    final authDataProvider = AuthDataProviderPrefs();
    final httpClient =
    HttpClient(configData.baseApiUrl, configData.apiKey, authDataProvider);

    final authProvider = AuthProviderApi(httpClient);
    final artistProvider = ArtistProviderApi(httpClient);
    final lyricProvider = LyricProviderApi(httpClient);
    final artistCacheProvider = ArtistCacheProviderDb(db);
    final lyricCacheProvider = LyricCacheProviderDb(db);
    final topRatedProvider = TopRatedProviderDb(db);

    _authRepository = AuthRepositoryConcrete(authProvider, authDataProvider);
    _artistRepository = ArtistRepositoryConcrete(
        artistProvider, artistCacheProvider, topRatedProvider);
    _lyricRepository = LyricRepositoryConcrete(
        lyricProvider, lyricCacheProvider, topRatedProvider);
  }

  AuthBloc authBloc({bool forceCreate = false}) {
    if (_authBloc == null || forceCreate) {
      _authBloc =
          AuthBloc(_authRepository, _artistRepository, _lyricRepository);
    }

    return _authBloc;
  }

  home.ArtistBloc homeArtistBloc({bool forceCreate = false}) {
    if (_homeArtistBloc == null || forceCreate) {
      _homeArtistBloc = home.ArtistBloc(_artistRepository);
    }

    return _homeArtistBloc;
  }

  home.LyricBloc homeLyricBloc({bool forceCreate = false}) {
    if (_homeLyricBloc == null || forceCreate) {
      _homeLyricBloc = home.LyricBloc(_lyricRepository);
    }

    return _homeLyricBloc;
  }
}
