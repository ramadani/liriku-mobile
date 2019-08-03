import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/collection/selector_event.dart';
import 'package:liriku/bloc/collection/selector_item.dart';
import 'package:liriku/bloc/collection/selector_state.dart';
import 'package:liriku/data/model/collection.dart';
import 'package:liriku/data/repository/collection_repository.dart';

class SelectorBLoc extends Bloc<SelectorEvent, SelectorState> {
  final CollectionRepository _collectionRepository;

  SelectorBLoc(this._collectionRepository);

  @override
  SelectorState get initialState => SelectorUninitialized();

  @override
  Stream<SelectorState> mapEventToState(SelectorEvent event) async* {
    try {
      if (event is FetchSelector) {
        yield SelectorLoading();

        final collections = await _collectionRepository.all();
        final List<SelectorItem> items = collections.map((Collection it) {
          return SelectorItem(collection: it);
        }).toList();

        yield SelectorLoaded(items: items);

        final firstItems =
            collections.where((Collection it) => it.id == 'a').toList();
        if (firstItems.length > 0) {
          dispatch(SelectSelector(id: firstItems.first.id));
        } else {
          dispatch(SelectSelector(id: collections.first.id));
        }
      } else if (event is SelectSelector && currentState is SelectorLoaded) {
        final state = currentState as SelectorLoaded;
        yield state.setSelected(event.id);
      }
    } catch (e) {
      print('selector err $e');
      yield SelectorError();
    }
  }
}
