import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/lyric/lyric_event.dart';
import 'package:liriku/bloc/lyric/lyric_state.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricBloc extends Bloc<LyricEvent, LyricState> {
  final LyricRepository _lyricRepository;

  LyricBloc(this._lyricRepository);

  @override
  LyricState get initialState => LyricLoading();

  @override
  Stream<LyricState> mapEventToState(LyricEvent event) async* {
    try {
      if (event is GetLyric) {
        final lyric = await _lyricRepository.getDetail(event.id);
        yield LyricLoaded(lyric: lyric);
      }
    } catch (e) {
      yield LyricError();
    }
  }
}
