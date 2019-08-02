import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/collection.dart';

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
  final List<Collection> collections;

  SelectorLoaded({this.collections}) : super([collections]);

  @override
  String toString() => 'SelectorLoaded { collectionSize: ${collections.length} }';
}

class SelectorError extends SelectorState {
  @override
  String toString() => 'SelectorError';
}
