import 'package:equatable/equatable.dart';

abstract class SelectorEvent extends Equatable {
  SelectorEvent([List props = const []]) : super(props);
}

class FetchSelector extends SelectorEvent {
  @override
  String toString() => 'FetchSelector';
}

class SelectSelector extends SelectorEvent {
  final String id;

  SelectSelector({this.id}) : super([id]);

  @override
  String toString() => 'SelectSelector { id: $id }';
}
