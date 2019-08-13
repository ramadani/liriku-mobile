import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/bloc/search/artist_list_event.dart';
import 'package:liriku/bloc/search/artist_list_state.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/repository/artist_repository.dart';

import 'search_form_bloc.dart';

class ArtistListBloc extends Bloc<ArtistListEvent, ArtistListState> {
  final SearchFormBloc _searchFormBloc;

  final ArtistRepository _artistRepository;

  StreamSubscription _searchSubscription;

  ArtistListBloc(this._searchFormBloc, this._artistRepository) {
    _searchSubscription = _searchFormBloc.state.listen((SearchFormState state) {
      if (state is SearchFormChanged) {
        dispatch(FetchArtistList(keyword: state.keyword));
      }
    });
  }

  @override
  ArtistListState get initialState => ArtistListUninitialized();

  @override
  Stream<ArtistListState> mapEventToState(ArtistListEvent event) async* {
    if (event is FetchArtistList) {
      yield* _mapFetchToState(event);
    } else if (event is FetchMoreArtistList &&
        currentState is ArtistListLoaded) {
      yield* _mapFetchMoreToState(currentState as ArtistListLoaded);
    }
  }

  @override
  void dispose() {
    _searchSubscription.cancel();
    super.dispose();
  }

  Stream<ArtistListState> _mapFetchToState(FetchArtistList event) async* {
    try {
      yield ArtistListLoading();

      final result = await _artistRepository.paginate(
        page: event.page,
        perPage: event.perPage,
        search: event.keyword,
      );

      if (result.artists.length > 0) {
        yield ArtistListLoaded(
          page: result.page,
          perPage: result.perPage,
          keyword: event.keyword,
          artists: result.artists,
          hasMorePages:
              result.artists.length == event.perPage && event.keyword != '',
        );
      } else {
        yield ArtistListEmpty();
      }
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield ArtistListError();
    }
  }

  Stream<ArtistListState> _mapFetchMoreToState(ArtistListLoaded state) async* {
    try {
      yield state.setFetchingMore();

      final result = await _artistRepository.paginate(
          page: state.page + 1, perPage: state.perPage, search: state.keyword);

      yield state.fetchedMore(
        page: result.page,
        newArtists: result.artists,
        hasMorePages: result.artists.length == state.perPage,
      );
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield ArtistListError();
    }
  }
}
