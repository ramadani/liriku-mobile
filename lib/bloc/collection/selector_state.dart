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

  SelectorLoaded({this.items}) : super([items]);

  @override
  String toString() => 'SelectorLoaded { itemSize: ${items.length} }';
}

class SelectorError extends SelectorState {
  @override
  String toString() => 'SelectorError';
}
