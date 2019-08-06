import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class SearchHidden extends SearchState {
  @override
  String toString() => 'SearchHidden';
}

class SearchVisible extends SearchState {
  final String keyword;
  final bool onSearch;

  SearchVisible({this.keyword = '', this.onSearch = false})
      : super([keyword, onSearch]);

  @override
  String toString() =>
      'SearchVisible { keyword: $keyword, onSearch: $onSearch }';
}
