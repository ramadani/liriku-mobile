import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/collection/selector_event.dart';
import 'package:liriku/bloc/collection/selector_state.dart';

class SelectorBLoc extends Bloc<SelectorEvent, SelectorState> {
  @override
  SelectorState get initialState => SelectorUninitialized();

  @override
  Stream<SelectorState> mapEventToState(SelectorEvent event) async* {
    try {
      if (event is FetchSelector) {
        yield SelectorLoading();
      }
    } catch (e) {
      yield SelectorError();
    }
  }
}