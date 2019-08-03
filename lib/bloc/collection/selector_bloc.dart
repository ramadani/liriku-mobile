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
      }
    } catch (e) {
      print('selector err $e');
      yield SelectorError();
    }
  }
}
