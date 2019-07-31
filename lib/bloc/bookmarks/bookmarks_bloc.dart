import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/bookmarks/bookmarks_event.dart';
import 'package:liriku/bloc/bookmarks/bookmarks_state.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final BookmarkBloc _bookmarkBloc;
  final LyricRepository _lyricRepository;

  StreamSubscription _bookmarkSubscription;

  BookmarksBloc(this._bookmarkBloc, this._lyricRepository) {
    _bookmarkSubscription = _bookmarkBloc.state.listen((BookmarkState state) {
      if (state is BookmarkChanged) {
        if (!state.bookmarked) {
          dispatch(RemoveBookmarkInList(
            lyricId: state.id,
            bookmarked: state.bookmarked,
          ));
        }
      }
    });
  }

  @override
  BookmarksState get initialState => BookmarksUninitialized();

  @override
  Stream<BookmarksState> mapEventToState(BookmarksEvent event) async* {
    if (event is FetchBookmarks) {
      yield* _mapFetchToState(event);
    } else if (event is FetchMoreBookmarks && currentState is BookmarksLoaded) {
      yield* _mapFetchMoreToState(currentState as BookmarksLoaded);
    } else if (event is RemoveBookmarkInList &&
        currentState is BookmarksLoaded) {
      yield* _mapRemoveBookmarkToState(
          currentState as BookmarksLoaded, event.lyricId);
    } else if (event is ResetBookmarks) {
      yield BookmarksUninitialized();
    }
  }

  Stream<BookmarksState> _mapFetchToState(FetchBookmarks event) async* {
    try {
      yield BookmarksLoading();

      final result = await _lyricRepository.paginateBookmarks(
        page: event.page,
        perPage: event.perPage,
        search: event.keyword,
      );

      if (result.lyrics.length > 0) {
        yield BookmarksLoaded(
          page: result.page,
          perPage: result.perPage,
          keyword: event.keyword,
          lyrics: result.lyrics,
          hasMorePages: result.lyrics.length == event.perPage,
        );
      } else {
        yield BookmarksEmpty();
      }
    } catch (e) {
      yield BookmarksError();
    }
  }

  Stream<BookmarksState> _mapFetchMoreToState(BookmarksLoaded state) async* {
    try {
      yield state.setFetchingMore();

      final result = await _lyricRepository.paginateBookmarks(
        page: state.page + 1,
        perPage: state.perPage,
        search: state.keyword,
      );

      yield state.fetchedMore(
        page: result.page,
        newLyrics: result.lyrics,
        hasMorePages: result.lyrics.length == state.perPage,
      );
    } on Exception catch (_) {
      yield BookmarksError();
    }
  }

  Stream<BookmarksState> _mapRemoveBookmarkToState(BookmarksLoaded state,
      String lyricId) async* {
    final lyrics = state.lyrics.where((Lyric it) => it.id != lyricId).toList();

    if (lyrics.length > 0) {
      yield BookmarksLoaded(
        page: state.page,
        perPage: state.perPage,
        keyword: state.keyword,
        lyrics: lyrics,
        hasMorePages: state.hasMorePages,
        fetchingMore: state.fetchingMore,
      );
    } else {
      yield BookmarksEmpty();
    }
  }

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }
}
