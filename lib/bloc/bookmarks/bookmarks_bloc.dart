import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/bookmarks/bookmarks_event.dart';
import 'package:liriku/bloc/bookmarks/bookmarks_state.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final BookmarkBloc _bookmarkBloc;
  final LyricRepository _lyricRepository;

  StreamSubscription _bookmarkSubscription;

  BookmarksBloc(this._bookmarkBloc, this._lyricRepository) {
    _bookmarkSubscription = _bookmarkBloc.state.listen((BookmarkState state) {
      if (state is BookmarkChanged) {
        print('bookmark ${state.id} ${state.bookmarked}');
        dispatch(ChangeBookmarkInList(
          lyricId: state.id,
          bookmarked: state.bookmarked,
        ));
      }
    });
  }

  @override
  BookmarksState get initialState => BookmarksUninitialized();

  @override
  Stream<BookmarksState> mapEventToState(BookmarksEvent event) async* {
    if (event is FetchBookmarks) {
      yield* _mapFetchToState(event);
    } else
    if (event is FetchMoreBookmarks && currentState is BookmarksLoaded) {} else
    if (event is ResetBookmarks) {
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

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }
}
