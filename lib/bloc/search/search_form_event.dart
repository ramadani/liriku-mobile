import 'package:equatable/equatable.dart';

abstract class SearchFormEvent extends Equatable {
  SearchFormEvent([List props = const []]) : super(props);
}

class SearchFromSubmitted extends SearchFormEvent {
  final String keyword;

  SearchFromSubmitted({this.keyword}) : super([keyword]);

  @override
  String toString() => 'SearchFromSubmitted { keyword: $keyword }';
}

class ResetSearchForm extends SearchFormEvent {
  @override
  String toString() => 'ResetSearchForm';
}
