import 'dart:async';

import 'package:bloc/bloc.dart';
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
        final lyrics = await _lyricRepository.getTopLyric();
        yield LyricLoaded(lyrics: lyrics);
      } else if (event is ChangeBookmarkInLyrics) {
        if (currentState is LyricLoaded) {
          final List<Lyric> lyrics =
          (currentState as LyricLoaded).lyrics.map((Lyric it) {
            return it.id == event.lyricId
                ? it.copyWith(bookmarked: event.bookmarked)
                : it.copyWith(bookmarked: it.bookmarked);
          }).toList();

          yield LyricLoaded(lyrics: lyrics);
        }
      }
    } on Exception catch (_) {
      yield LyricError();
    }
  }

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }
}
