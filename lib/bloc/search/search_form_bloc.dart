import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/search/search_form_event.dart';
import 'package:liriku/bloc/search/search_form_state.dart';

class SearchFormBloc extends Bloc<SearchFormEvent, SearchFormState> {
  @override
  SearchFormState get initialState => SearchFormUninitialized();

  @override
  Stream<SearchFormState> mapEventToState(SearchFormEvent event) async* {
    if (event is SearchFromSubmitted) {
      yield SearchFormChanged(keyword: event.keyword);
    } else if (event is ResetSearchForm) {
      yield SearchFormChanged(keyword: '');
      yield SearchFormUninitialized();
    }
  }
}
