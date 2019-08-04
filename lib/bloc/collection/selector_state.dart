import 'package:equatable/equatable.dart';
import 'package:liriku/bloc/collection/bloc.dart';

abstract class SelectorState extends Equatable {
  SelectorState([List props = const []]) : super(props);
}

class SelectorUninitialized extends SelectorState {
  @override
  String toString() => 'SelectorUninitialized';
}

class SelectorLoading extends SelectorState {
  @override
  String toString() => 'SelectorLoading';
}

class SelectorLoaded extends SelectorState {
  final List<SelectorItem> items;
  final String selectedId;

  SelectorLoaded({this.items, this.selectedId}) : super([items]);

  @override
  String toString() =>
      'SelectorLoaded { itemSize: ${items.length}, selectedId: $selectedId} }';

  SelectorLoaded setSelected(String id) {
    final List<SelectorItem> items = this.items.map((SelectorItem it) {
      return SelectorItem(
        collection: it.collection,
        selected: it.collection.id == id,
      );
    }).toList();

    return SelectorLoaded(items: items, selectedId: id);
  }
}

class SelectorError extends SelectorState {
  @override
  String toString() => 'SelectorError';
}
