import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/recentlyread/recently_read_event.dart';
import 'package:liriku/bloc/recentlyread/recently_read_state.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class RecentlyReadBloc extends Bloc<RecentlyReadEvent, RecentlyReadState> {
  final BookmarkBloc _bookmarkBloc;
  final LyricRepository _lyricRepository;

  StreamSubscription _bookmarkSubscription;

  int _adPerPage = 15;

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
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield RecentlyReadError();
    }
  }

  Stream<RecentlyReadState> _mapFetchToState(FetchRecentlyRead event) async* {
    final results = await _lyricRepository.getRecentlyRead(limit: event.limit);

    if (results.length > 0) {
      final len = results.length;
      final adRepeatedly = len > _adPerPage;
      final adIndex =
          _getAdIndex(len > _adPerPage ? _adPerPage : len, len > _adPerPage);

      yield RecentlyReadLoaded(
        lyrics: results,
        adRepeatedly: adRepeatedly,
        adIndex: adIndex,
      );
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

      yield RecentlyReadLoaded(
        lyrics: lyrics,
        adRepeatedly: state.adRepeatedly,
        adIndex: state.adIndex,
      );
    }
  }

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }

  int _getAdIndex(int size, bool gtSize) {
    final start = size - 3;
    if (start > 0 && gtSize) {
      final random = Random();
      final num = start + random.nextInt(size - start);
      return num - 1;
    }

    return size - 1;
  }
}
