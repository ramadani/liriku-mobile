import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmarks/bookmarks_event.dart';
import 'package:liriku/bloc/bookmarks/bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  @override
  BookmarksState get initialState => BookmarksUninitialized();

  @override
  Stream<BookmarksState> mapEventToState(BookmarksEvent event) async* {
    if (event is FetchBookmarks) {
      yield* _mapFetchToState(event);
    } else if (event is FetchMoreBookmarks &&
        currentState is BookmarksLoaded) {}
  }

  Stream<BookmarksState> _mapFetchToState(FetchBookmarks event) async* {
    try {
      yield BookmarksLoading();
    } catch (e) {
      yield BookmarksError();
    }
  }
}
