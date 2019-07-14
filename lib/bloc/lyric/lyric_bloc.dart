import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/lyric/lyric_event.dart';
import 'package:liriku/bloc/lyric/lyric_state.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricBloc extends Bloc<LyricEvent, LyricState> {
  final LyricRepository _lyricRepository;
  final BookmarkBloc _bookmarkBloc;

  LyricBloc(this._lyricRepository, this._bookmarkBloc);

  @override
  LyricState get initialState => LyricLoading();

  @override
  Stream<LyricState> mapEventToState(LyricEvent event) async* {
    try {
      if (event is GetLyric) {
        final lyric = await _lyricRepository.getDetail(event.id);
        _bookmarkBloc.dispatch(InitBookmark(
          id: lyric.id,
          bookmarked: lyric.bookmarked,
        ));
        yield LyricLoaded(lyric: lyric);
      }
    } catch (e) {
      yield LyricError();
    }
  }
}
