import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmark/bookmark_event.dart';
import 'package:liriku/bloc/bookmark/bookmark_state.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final LyricRepository _lyricRepository;

  BookmarkBloc(this._lyricRepository);

  @override
  BookmarkState get initialState => BookmarkUninitialized();

  @override
  Stream<BookmarkState> mapEventToState(BookmarkEvent event) async* {
    try {
      if (event is InitBookmark) {
        yield BookmarkInitialized(id: event.id, bookmarked: event.bookmarked);
      } else if (event is BookmarkPressed) {
        await _lyricRepository.setBookmark(event.id, event.bookmarked);
        yield BookmarkChanged(id: event.id, bookmarked: event.bookmarked);
      }
    } on Exception catch (_) {
      yield BookmarkError();
    }
  }
}
