import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/bloc/search/lyric_list_event.dart';
import 'package:liriku/bloc/search/lyric_list_state.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricListBloc extends Bloc<LyricListEvent, LyricListState> {
  StreamSubscription _searchSubscription;
  final SearchFormBloc _searchFormBloc;
  final LyricRepository _lyricRepository;

  LyricListBloc(this._searchFormBloc, this._lyricRepository) {
    _searchSubscription = _searchFormBloc.state.listen((SearchFormState state) {
      if (state is SearchFormChanged) {
        dispatch(FetchLyricList(page: 1, perPage: 100, keyword: state.keyword));
      }
    });
  }

  @override
  LyricListState get initialState => LyricListUninitialized();

  @override
  Stream<LyricListState> mapEventToState(LyricListEvent event) async* {
    try {
      if (event is FetchLyricList) {
        yield* _mapFetchToState(event);
      } else if (event is FetchMoreLyricList &&
          currentState is LyricListLoaded) {
        yield* _mapFetchMoreToState(event, currentState as LyricListLoaded);
      }
    } on Exception catch (_) {
      yield LyricListError();
    }
  }

  @override
  void dispose() {
    _searchSubscription.cancel();
    super.dispose();
  }

  Stream<LyricListState> _mapFetchToState(FetchLyricList event) async* {
    yield LyricListLoading();

    final result = await _lyricRepository.paginate(
        page: event.page, perPage: event.perPage, search: event.keyword);

    yield LyricListLoaded(
      page: result.page,
      perPage: result.perPage,
      keyword: event.keyword,
      lyrics: result.lyrics,
    );
  }

  Stream<LyricListState> _mapFetchMoreToState(
      FetchMoreLyricList event, LyricListLoaded state) async* {
    yield LyricListLoadingMore(
        page: state.page + 1, perPage: state.perPage, keyword: state.keyword);

    final result = await _lyricRepository.paginate(
        page: state.page + 1, perPage: state.perPage, search: state.keyword);

    yield LyricListLoaded(
      page: result.page,
      perPage: result.perPage,
      keyword: state.keyword,
      lyrics: state.lyrics + result.lyrics,
    );
  }
}
