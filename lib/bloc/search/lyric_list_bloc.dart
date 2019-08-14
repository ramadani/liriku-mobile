import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
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

  int _adPerPage = 20;

  LyricListBloc(
    this._searchFormBloc,
    this._bookmarkBloc,
    this._lyricRepository,
  ) {
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
      yield* _mapFetchMoreToState(currentState as LyricListLoaded);
    } else if (event is ChangeBookmarkInList) {
      if (currentState is LyricListLoaded) {
        yield* _mapChangeBookmarkToState(
            event, currentState as LyricListLoaded);
      }
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
        final len = result.lyrics.length;
        final adRepeatedly = len > _adPerPage;
        final adIndex = _getAdIndex(len > _adPerPage ? _adPerPage : len);

        yield LyricListLoaded(
          page: result.page,
          perPage: result.perPage,
          keyword: event.keyword,
          lyrics: result.lyrics,
          hasMorePages:
              result.lyrics.length == event.perPage && event.keyword != '',
          adRepeatedly: adRepeatedly,
          adIndex: adIndex,
        );
      } else {
        yield LyricListEmpty();
      }
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield LyricListError();
    }
  }

  Stream<LyricListState> _mapFetchMoreToState(LyricListLoaded state) async* {
    try {
      yield state.setFetchingMore();

      final result = await _lyricRepository.paginate(
          page: state.page + 1, perPage: state.perPage, search: state.keyword);

      yield state.fetchedMore(
        page: result.page,
        newLyrics: result.lyrics,
        hasMorePages: result.lyrics.length == state.perPage,
      );
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield LyricListError();
    }
  }

  Stream<LyricListState> _mapChangeBookmarkToState(
      ChangeBookmarkInList event, LyricListLoaded state) async* {
    if (state.lyrics.length > 0) {
      final lyrics = state.lyrics.map((Lyric it) {
        return it.id == event.lyricId
            ? it.copyWith(bookmarked: event.bookmarked)
            : it.copyWith(bookmarked: it.bookmarked);
      }).toList();

      yield state.updateLyrics(lyrics);
    }
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
