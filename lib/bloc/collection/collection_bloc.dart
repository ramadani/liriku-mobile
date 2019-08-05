import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/bloc/collection/bloc.dart';
import 'package:liriku/bloc/collection/collection_event.dart';
import 'package:liriku/bloc/collection/collection_state.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final SelectorBLoc _selectorBLoc;
  final ArtistRepository _artistRepository;

  StreamSubscription _selectorSubscription;

  CollectionBloc(this._selectorBLoc, this._artistRepository) {
    _selectorSubscription = _selectorBLoc.state.listen((SelectorState state) {
      if (state is SelectorLoaded) {
        if (state.selectedId != null) {
          dispatch(FetchCollection(id: state.selectedId));
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
      );

      if (cacheResult.artists.length > 0) {
        yield CollectionLoaded(
          id: event.id,
          artists: cacheResult.artists,
          page: cacheResult.page,
          perPage: cacheResult.perPage,
          hasMorePages: cacheResult.artists.length == event.perPage,
          fetchingMore: false,
        );
      }

      final result = await _artistRepository.fetchAndSync(
        page: event.page,
        perPage: event.perPage,
        collection: event.id,
      );

      if (result.artists.length > 0) {
        yield CollectionLoaded(
          id: event.id,
          artists: result.artists,
          page: result.page,
          perPage: result.perPage,
          hasMorePages: result.artists.length == event.perPage,
          fetchingMore: false,
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
    super.dispose();
  }
}
