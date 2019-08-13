import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/collection/search_event.dart';
import 'package:liriku/bloc/collection/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  SearchState get initialState => SearchHidden();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is ShowSearchForm) {
      yield SearchVisible(onSearch: false);
    } else if (event is OnSearch) {
      yield SearchVisible(keyword: event.keyword, onSearch: true);
    } else if (event is CloseSearchForm) {
      yield SearchHidden();
    }
  }
}
