import 'package:flutter/material.dart';
import 'package:liriku/bloc/auth/auth_bloc.dart';
import 'package:liriku/bloc/home/bloc.dart' as home;
import 'package:liriku/bloc/lyric/bloc.dart';
import 'package:liriku/bloc/playlist/playlist_bloc.dart';
import 'package:liriku/config/json_config.dart';
import 'package:liriku/data/provider/api/artist_provider_api.dart';
import 'package:liriku/data/provider/api/auth_provider_api.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/api/lyric_provider_api.dart';
import 'package:liriku/data/provider/app_data_provider.dart';
import 'package:liriku/data/provider/db/artist_cache_provider_db.dart';
import 'package:liriku/data/provider/db/lyric_cache_provider_db.dart';
import 'package:liriku/data/provider/db/sqlite_provider.dart';
import 'package:liriku/data/provider/db/top_rated_provider_db.dart';
import 'package:liriku/data/provider/prefs/app_data_provider_prefs.dart';
import 'package:liriku/data/repository/artist_repository.dart';
import 'package:liriku/data/repository/auth_repository.dart';
import 'package:liriku/data/repository/concrete/artist_repository_concrete.dart';
import 'package:liriku/data/repository/concrete/auth_repository_concrete.dart';
import 'package:liriku/data/repository/concrete/lyric_repository_concrete.dart';
import 'package:liriku/data/repository/lyric_repository.dart';
import 'package:meta/meta.dart';

class InjectorWidget extends InheritedWidget {
  String _envFilename;

  AppDataProvider _appDataProvider;
  AuthRepository _authRepository;
  ArtistRepository _artistRepository;
  LyricRepository _lyricRepository;

  AuthBloc _authBloc;
  home.ArtistBloc _homeArtistBloc;
  home.LyricBloc _homeLyricBloc;
  PlaylistBloc _playlistBloc;
  LyricBloc _lyricBloc;

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
    _appDataProvider = AppDataProviderPrefs();

    final db = await SQLiteProvider().open();
    final httpClient =
    HttpClient(configData.baseApiUrl, configData.apiKey, _appDataProvider);
    final authProvider = AuthProviderApi(httpClient);
    final artistProvider = ArtistProviderApi(httpClient);
    final lyricProvider = LyricProviderApi(httpClient);
    final artistCacheProvider = ArtistCacheProviderDb(db);
    final lyricCacheProvider = LyricCacheProviderDb(db);
    final topRatedProvider = TopRatedProviderDb(db);

    _authRepository = AuthRepositoryConcrete(authProvider, _appDataProvider);
    _artistRepository = ArtistRepositoryConcrete(artistProvider,
        artistCacheProvider, lyricCacheProvider, topRatedProvider);
    _lyricRepository = LyricRepositoryConcrete(lyricProvider,
        lyricCacheProvider, artistCacheProvider, topRatedProvider);
  }

  AuthBloc authBloc({bool forceCreate = false}) {
    if (_authBloc == null || forceCreate) {
      _authBloc = AuthBloc(_appDataProvider, _authRepository, _artistRepository,
          _lyricRepository);
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

  PlaylistBloc playlistBloc({bool forceCreate = false}) {
    if (_playlistBloc == null || forceCreate) {
      _playlistBloc = PlaylistBloc(_artistRepository);
    }

    return _playlistBloc;
  }

  LyricBloc lyricBloc({bool forceCreate = false}) {
    if (_lyricBloc == null || forceCreate) {
      return _lyricBloc = LyricBloc(_lyricRepository);
    }

    return _lyricBloc;
  }
}
