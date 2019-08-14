import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/home/lyric_event.dart';
import 'package:liriku/bloc/home/lyric_state.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricBloc extends Bloc<LyricEvent, LyricState> {
  final LyricRepository _lyricRepository;
  final BookmarkBloc _bookmarkBloc;
  StreamSubscription _bookmarkSubscription;

  LyricBloc(this._lyricRepository, this._bookmarkBloc) {
    _bookmarkSubscription = _bookmarkBloc.state.listen((BookmarkState state) {
      if (state is BookmarkChanged) {
        dispatch(ChangeBookmarkInLyrics(
          lyricId: state.id,
          bookmarked: state.bookmarked,
        ));
      }
    });
  }

  @override
  LyricState get initialState => LyricLoading();

  @override
  Stream<LyricState> mapEventToState(LyricEvent event) async* {
    try {
      if (event is FetchTopLyric) {
        yield* _mapFetchToState();
      } else if (event is ChangeBookmarkInLyrics) {
        yield* _mapBookmarkToState(event);
      }
    } on Exception catch (e, s) {
      await FlutterCrashlytics().logException(e, s);
      yield LyricError();
    }
  }

  Stream<LyricState> _mapFetchToState() async* {
    final lyrics = await _lyricRepository.getTopLyric();
    if (lyrics.length > 0) {
      final adIndex = _getAdIndex(lyrics.length);
      yield LyricLoaded(lyrics: lyrics, adIndex: adIndex);
    } else {
      await _lyricRepository.syncTopLyric();

      final lyrics = await _lyricRepository.getTopLyric();
      final adIndex = _getAdIndex(lyrics.length);
      yield LyricLoaded(lyrics: lyrics, adIndex: adIndex);
    }
  }

  Stream<LyricState> _mapBookmarkToState(ChangeBookmarkInLyrics event) async* {
    if (currentState is LyricLoaded) {
      final state = currentState as LyricLoaded;
      final List<Lyric> lyrics = state.lyrics.map((Lyric it) {
        return it.id == event.lyricId
            ? it.copyWith(bookmarked: event.bookmarked)
            : it.copyWith(bookmarked: it.bookmarked);
      }).toList();

      yield LyricLoaded(lyrics: lyrics, adIndex: state.adIndex);
    }
  }

  int _getAdIndex(int size) {
    final start = size - 3;
    if (start > 0) {
      final random = Random();
      final num = start + random.nextInt(size - start);
      return num - 1;
    }

    return size - 1;
  }

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }
}
