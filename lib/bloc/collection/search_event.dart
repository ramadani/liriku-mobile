import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]) : super(props);
}

class ShowSearchForm extends SearchEvent {
  @override
  String toString() => 'ShowSearchForm';
}

class OnSearch extends SearchEvent {
  final String keyword;

  OnSearch({this.keyword}) : super([keyword]);

  @override
  String toString() => 'OnSearch { keyword: $keyword }';
}

class CloseSearchForm extends SearchEvent {
  @override
  String toString() => 'CloseSearchForm';
}
