import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/home/lyric_event.dart';
import 'package:liriku/bloc/home/lyric_state.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricBloc extends Bloc<LyricEvent, LyricState> {
  final LyricRepository _lyricRepository;

  LyricBloc(this._lyricRepository);

  @override
  LyricState get initialState => LyricLoading();

  @override
  Stream<LyricState> mapEventToState(LyricEvent event) async* {
    try {
      if (event is FetchTopLyric) {
        final lyrics = await _lyricRepository.getTopLyric();
        yield LyricLoaded(lyrics: lyrics);
      }
    } catch (e) {
      yield LyricError();
    }
  }
}
