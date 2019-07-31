import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/recentlyread/recently_read_event.dart';
import 'package:liriku/bloc/recentlyread/recently_read_state.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class RecentlyReadBloc extends Bloc<RecentlyReadEvent, RecentlyReadState> {
  final BookmarkBloc _bookmarkBloc;
  final LyricRepository _lyricRepository;

  StreamSubscription _bookmarkSubscription;

  RecentlyReadBloc(this._bookmarkBloc, this._lyricRepository) {
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
  RecentlyReadState get initialState => RecentlyReadUninitialized();

  @override
  Stream<RecentlyReadState> mapEventToState(RecentlyReadEvent event) async* {
    try {
      if (event is FetchRecentlyRead) {
        yield* _mapFetchToState(event);
      } else if (event is ChangeBookmarkInList &&
          currentState is RecentlyReadLoaded) {
        yield* _mapChangeBookmarkToState(
            event, currentState as RecentlyReadLoaded);
      }
    } catch (e) {
      yield RecentlyReadError();
    }
  }

  Stream<RecentlyReadState> _mapFetchToState(FetchRecentlyRead event) async* {
    final results = await _lyricRepository.getRecentlyRead(limit: event.limit);

    if (results.length > 0) {
      yield RecentlyReadLoaded(lyrics: results);
    } else {
      yield RecentlyReadEmpty();
    }
  }

  Stream<RecentlyReadState> _mapChangeBookmarkToState(
      ChangeBookmarkInList event, RecentlyReadLoaded state) async* {
    if (state.lyrics.length > 0) {
      final lyrics = state.lyrics.map((Lyric it) {
        return it.id == event.lyricId
            ? it.copyWith(bookmarked: event.bookmarked)
            : it.copyWith(bookmarked: it.bookmarked);
      }).toList();

      yield RecentlyReadLoaded(lyrics: lyrics);
    }
  }

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }
}
