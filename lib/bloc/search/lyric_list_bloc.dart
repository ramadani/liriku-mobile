import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/bookmark/bookmark_bloc.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricListBloc extends Bloc<LyricListEvent, LyricListState> {
  final SearchFormBloc _searchFormBloc;
  final BookmarkBloc _bookmarkBloc;

  final LyricRepository _lyricRepository;

  StreamSubscription _searchSubscription;
  StreamSubscription _bookmarkSubscription;

  LyricListBloc(this._searchFormBloc,
      this._bookmarkBloc,
      this._lyricRepository,) {
    _searchSubscription = _searchFormBloc.state.listen((SearchFormState state) {
      if (state is SearchFormChanged) {
        dispatch(FetchLyricList(keyword: state.keyword));
      }
    });

    _bookmarkSubscription = _bookmarkBloc.state.listen((BookmarkState state) {
      if (state is BookmarkChanged) {
        dispatch(ChangeBookmarkInList(
          lyricId: state.id,
          bookmarked: state.bookmarked,
        ));
      }
    });
  }

  @override
  LyricListState get initialState => LyricListUninitialized();

  @override
  Stream<LyricListState> mapEventToState(LyricListEvent event) async* {
    if (event is FetchLyricList) {
      yield* _mapFetchToState(event);
    } else if (event is FetchMoreLyricList && currentState is LyricListLoaded) {
      yield* _mapFetchMoreToState(event, currentState as LyricListLoaded);
    } else if (event is ChangeBookmarkInList) {
      if (currentState is LyricListLoaded) {
        yield* _mapChangeBookmarkToState(
            event, currentState as LyricListLoaded);
      }
    } else if (event is ResetLyricList) {
      yield LyricListUninitialized();
    }
  }

  @override
  void dispose() {
    _searchSubscription.cancel();
    _bookmarkSubscription.cancel();
    super.dispose();
  }

  Stream<LyricListState> _mapFetchToState(FetchLyricList event) async* {
    try {
      yield LyricListLoading();

      final result = await _lyricRepository.paginate(
          page: event.page, perPage: event.perPage, search: event.keyword);

      if (result.lyrics.length > 0) {
        yield LyricListLoaded(
          page: result.page,
          perPage: result.perPage,
          keyword: event.keyword,
          lyrics: result.lyrics,
        );
      } else {
        yield LyricListEmpty();
      }
    } catch (e) {
      yield LyricListError();
    }
  }

  Stream<LyricListState> _mapFetchMoreToState(
      FetchMoreLyricList event, LyricListLoaded state) async* {
    try {
      final result = await _lyricRepository.paginate(
          page: state.page + 1, perPage: state.perPage, search: state.keyword);

      yield LyricListLoaded(
        page: result.page,
        perPage: result.perPage,
        keyword: state.keyword,
        lyrics: state.lyrics + result.lyrics,
      );
    } catch (e) {
      yield LyricListError();
    }
  }

  Stream<LyricListState> _mapChangeBookmarkToState(ChangeBookmarkInList event,
      LyricListLoaded state) async* {
    if (state.lyrics.length > 0) {
      final lyrics = state.lyrics.map((Lyric it) {
        return it.id == event.lyricId
            ? it.copyWith(bookmarked: event.bookmarked)
            : it.copyWith(bookmarked: it.bookmarked);
      }).toList();

      yield LyricListLoaded(lyrics: lyrics);
    }
  }
}
