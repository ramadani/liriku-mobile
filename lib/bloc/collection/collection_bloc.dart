import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/bloc/collection/bloc.dart';
import 'package:liriku/bloc/collection/collection_event.dart';
import 'package:liriku/bloc/collection/collection_state.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final SelectorBLoc _selectorBLoc;
  final SearchBloc _searchBloc;
  final ArtistRepository _artistRepository;

  StreamSubscription _selectorSubscription;
  StreamSubscription _searchSubscription;

  int _adPerPage = 20;

  CollectionBloc(this._selectorBLoc, this._searchBloc, this._artistRepository) {
    _selectorSubscription = _selectorBLoc.state.listen((SelectorState state) {
      if (state is SelectorLoaded) {
        if (state.selectedId != null) {
          dispatch(FetchCollection(id: state.selectedId));
        }
      }
    });

    _searchSubscription = _searchBloc.state.listen((SearchState state) {
      if (state is SearchVisible) {
        if (state.onSearch && currentState is CollectionLoaded) {
          final collectionId = (currentState as CollectionLoaded).id;

          dispatch(FetchCollection(id: collectionId, keyword: state.keyword));
        }
      }
    });
  }

  @override
  CollectionState get initialState => CollectionUninitialized();

  @override
  Stream<CollectionState> mapEventToState(CollectionEvent event) async* {
    if (event is FetchCollection) {
      yield* _mapFetchToState(event);
    } else if (event is FetchMoreCollection &&
        currentState is CollectionLoaded) {
      yield* _mapFetchMoreToState(currentState as CollectionLoaded);
    }
  }

  Stream<CollectionState> _mapFetchToState(FetchCollection event) async* {
    try {
      yield CollectionLoading();

      final cacheResult = await _artistRepository.fetchFromCache(
        page: event.page,
        perPage: event.perPage,
        collection: event.id,
        search: event.keyword,
      );

      if (cacheResult.artists.length > 0) {
        final len = cacheResult.artists.length;
        final adRepeatedly = len > _adPerPage;
        final adIndex = _getAdIndex(len > _adPerPage ? _adPerPage : len);

        yield CollectionLoaded(
          id: event.id,
          artists: cacheResult.artists,
          page: cacheResult.page,
          perPage: cacheResult.perPage,
          keyword: event.keyword,
          hasMorePages: cacheResult.artists.length == event.perPage,
          fetchingMore: false,
          adRepeatedly: adRepeatedly,
          adIndex: adIndex,
        );
      }

      final result = await _artistRepository.fetchAndSync(
        page: event.page,
        perPage: event.perPage,
        collection: event.id,
        search: event.keyword,
      );

      if (result.artists.length > 0) {
        final len = result.artists.length;
        final adRepeatedly = len > _adPerPage;
        final adIndex = _getAdIndex(len > _adPerPage ? _adPerPage : len);

        yield CollectionLoaded(
          id: event.id,
          artists: result.artists,
          page: result.page,
          perPage: result.perPage,
          keyword: event.keyword,
          hasMorePages: result.artists.length == event.perPage,
          fetchingMore: false,
          adRepeatedly: adRepeatedly,
          adIndex: adIndex,
        );
      } else {
        yield CollectionEmpty();
      }
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield CollectionError();
    }
  }

  Stream<CollectionState> _mapFetchMoreToState(CollectionLoaded state) async* {
    try {
      yield state.setFetchingMore();

      final cacheResult = await _artistRepository.fetchFromCache(
        page: state.page + 1,
        perPage: state.perPage,
        collection: state.id,
        search: state.keyword,
      );

      yield state.fetchedMore(
        page: cacheResult.page,
        newArtists: cacheResult.artists,
        hasMorePages: cacheResult.artists.length == state.perPage,
      );

      final result = await _artistRepository.fetchAndSync(
        page: state.page + 1,
        perPage: state.perPage,
        collection: state.id,
        search: state.keyword,
      );

      yield state.fetchedMore(
        page: result.page,
        newArtists: result.artists,
        hasMorePages: result.artists.length == state.perPage,
      );
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield CollectionError();
    }
  }

  @override
  void dispose() {
    _selectorSubscription.cancel();
    _searchSubscription.cancel();
    super.dispose();
  }

  int _getAdIndex(int size) {
    final start = size - 5;
    if (start > 0) {
      final random = Random();
      final num = start + random.nextInt(size - start);
      return num - 1;
    }

    return size;
  }
}
