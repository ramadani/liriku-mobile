import 'dart:async';

import 'package:bloc/bloc.dart';
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
    try {
      if (event is FetchArtistList) {
        yield* _mapFetchToState(event);
      }
    } catch (e) {
      yield ArtistListError();
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
          artists: result.artists,
        );
      } else {
        yield ArtistListEmpty();
      }
    } catch (e) {
      print(e);
      yield ArtistListError();
    }
  }
}
