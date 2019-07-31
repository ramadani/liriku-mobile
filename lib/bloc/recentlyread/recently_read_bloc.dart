import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/recentlyread/recently_read_event.dart';
import 'package:liriku/bloc/recentlyread/recently_read_state.dart';

class RecentlyReadBloc extends Bloc<RecentlyReadEvent, RecentlyReadState> {
  @override
  RecentlyReadState get initialState => RecentlyReadUninitialized();

  @override
  Stream<RecentlyReadState> mapEventToState(RecentlyReadEvent event) async* {
    try {
      if (event is FetchRecentlyRead) {

      } else if (event is ChangeBookmarkInList) {

      }
    } catch (e) {
      yield RecentlyReadError();
    }
  }
}
