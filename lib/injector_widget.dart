import 'package:flutter/material.dart';
import 'package:liriku/bloc/auth/auth_bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/bookmarks/bloc.dart';
import 'package:liriku/bloc/collection/bloc.dart' as col;
import 'package:liriku/bloc/home/bloc.dart' as home;
import 'package:liriku/bloc/lyric/bloc.dart';
import 'package:liriku/bloc/playlist/playlist_bloc.dart';
import 'package:liriku/bloc/recentlyread/bloc.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/config/json_config.dart';
import 'package:liriku/data/provider/api/artist_provider_api.dart';
import 'package:liriku/data/provider/api/auth_provider_api.dart';
import 'package:liriku/data/provider/api/collection_provider_api.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/api/lyric_provider_api.dart';
import 'package:liriku/data/provider/app_data_provider.dart';
import 'package:liriku/data/provider/db/artist_cache_provider_db.dart';
import 'package:liriku/data/provider/db/bookmarkable_provider_db.dart';
import 'package:liriku/data/provider/db/collection_cache_provider_db.dart';
import 'package:liriku/data/provider/db/lyric_cache_provider_db.dart';
import 'package:liriku/data/provider/db/sqlite_provider.dart';
import 'package:liriku/data/provider/db/top_rated_provider_db.dart';
import 'package:liriku/data/provider/prefs/app_data_provider_prefs.dart';
import 'package:liriku/data/repository/artist_repository.dart';
import 'package:liriku/data/repository/auth_repository.dart';
import 'package:liriku/data/repository/collection_repository.dart';
import 'package:liriku/data/repository/concrete/artist_repository_concrete.dart';
import 'package:liriku/data/repository/concrete/auth_repository_concrete.dart';
import 'package:liriku/data/repository/concrete/collection_repository_concrete.dart';
import 'package:liriku/data/repository/concrete/lyric_repository_concrete.dart';
import 'package:liriku/data/repository/lyric_repository.dart';
import 'package:meta/meta.dart';

class InjectorWidget extends InheritedWidget {
  String _envFilename;

  AppDataProvider _appDataProvider;
  AuthRepository _authRepository;
  CollectionRepository _collectionRepository;
  ArtistRepository _artistRepository;
  LyricRepository _lyricRepository;

  AuthBloc _authBloc;
  home.ArtistBloc _homeArtistBloc;
  home.LyricBloc _homeLyricBloc;
  PlaylistBloc _playlistBloc;
  LyricBloc _lyricBloc;
  BookmarkBloc _bookmarkBloc;
  SearchFormBloc _searchFormBloc;
  LyricListBloc _lyricListBloc;
  ArtistListBloc _artistListBloc;
  col.SelectorBLoc _selectorBLoc;
  col.CollectionBloc _collectionBloc;
  col.SearchBloc _searchCollectionBloc;
  BookmarksBloc _bookmarksBloc;
  RecentlyReadBloc _recentlyReadBloc;

  InjectorWidget({
    Key key,
    @required Widget child,
    @required String envFilename,
  })  : assert(child != null),
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
    final collectionProvider = CollectionProviderApi(httpClient);
    final artistProvider = ArtistProviderApi(httpClient);
    final lyricProvider = LyricProviderApi(httpClient);

    final collectionCacheProvider = CollectionCacheProviderDb(db);
    final artistCacheProvider = ArtistCacheProviderDb(db);
    final lyricCacheProvider = LyricCacheProviderDb(db);
    final topRatedProvider = TopRatedProviderDb(db);
    final bookmarkableProvider = BookmarkableProviderDb(db);

    _authRepository = AuthRepositoryConcrete(authProvider, _appDataProvider);
    _collectionRepository = CollectionRepositoryConcrete(
        collectionProvider, collectionCacheProvider);
    _artistRepository = ArtistRepositoryConcrete(artistProvider,
        artistCacheProvider, lyricCacheProvider, topRatedProvider);
    _lyricRepository = LyricRepositoryConcrete(
      lyricProvider,
      lyricCacheProvider,
      topRatedProvider,
      bookmarkableProvider,
      _artistRepository,
    );
  }

  AuthBloc authBloc({bool forceCreate = false}) {
    if (_authBloc == null || forceCreate) {
      _authBloc = AuthBloc(
        _appDataProvider,
        _authRepository,
        _artistRepository,
        _lyricRepository,
        _collectionRepository,
      );
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
      _homeLyricBloc = home.LyricBloc(_lyricRepository, bookmarkBloc());
    }

    return _homeLyricBloc;
  }

  PlaylistBloc playlistBloc({bool forceCreate = false}) {
    if (_playlistBloc == null || forceCreate) {
      _playlistBloc = PlaylistBloc(_artistRepository, bookmarkBloc());
    }

    return _playlistBloc;
  }

  LyricBloc lyricBloc({bool forceCreate = false}) {
    if (_lyricBloc == null || forceCreate) {
      _lyricBloc = LyricBloc(_lyricRepository, bookmarkBloc());
    }

    return _lyricBloc;
  }

  BookmarkBloc bookmarkBloc({bool forceCreate = false}) {
    if (_bookmarkBloc == null || forceCreate) {
      _bookmarkBloc = BookmarkBloc(_lyricRepository);
    }

    return _bookmarkBloc;
  }

  SearchFormBloc searchFormBloc({bool forceCreate = false}) {
    if (_searchFormBloc == null || forceCreate) {
      _searchFormBloc = SearchFormBloc();
    }

    return _searchFormBloc;
  }

  LyricListBloc lyricListBloc({bool forceCreate = false}) {
    if (_lyricListBloc == null || forceCreate) {
      _lyricListBloc = LyricListBloc(
        searchFormBloc(),
        bookmarkBloc(),
        _lyricRepository,
      );
    }

    return _lyricListBloc;
  }

  ArtistListBloc artistListBloc({bool forceCreate = false}) {
    if (_artistListBloc == null || forceCreate) {
      _artistListBloc = ArtistListBloc(searchFormBloc(), _artistRepository);
    }

    return _artistListBloc;
  }

  BookmarksBloc bookmarksBloc({bool forceCreate = false}) {
    if (_bookmarksBloc == null || forceCreate) {
      _bookmarksBloc = BookmarksBloc(bookmarkBloc(), _lyricRepository);
    }

    return _bookmarksBloc;
  }

  RecentlyReadBloc recentlyReadBloc({bool forceCreate = false}) {
    if (_recentlyReadBloc == null || forceCreate) {
      _recentlyReadBloc = RecentlyReadBloc(bookmarkBloc(), _lyricRepository);
    }

    return _recentlyReadBloc;
  }

  col.SelectorBLoc selectorBLoc({bool forceCreate = false}) {
    if (_selectorBLoc == null || forceCreate) {
      _selectorBLoc = col.SelectorBLoc(_collectionRepository);
    }

    return _selectorBLoc;
  }

  col.CollectionBloc collectionBloc({bool forceCreate = false}) {
    if (_collectionBloc == null || forceCreate) {
      _collectionBloc = col.CollectionBloc(
        selectorBLoc(),
        searchCollectionBloc(),
        _artistRepository,
      );
    }

    return _collectionBloc;
  }

  col.SearchBloc searchCollectionBloc({bool forceCreate = false}) {
    if (_searchCollectionBloc == null || forceCreate) {
      _searchCollectionBloc = col.SearchBloc();
    }

    return _searchCollectionBloc;
  }
}
