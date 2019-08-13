import 'package:equatable/equatable.dart';

abstract class SearchFormState extends Equatable {
  SearchFormState([List props = const []]) : super(props);
}

class SearchFormUninitialized extends SearchFormState {
  @override
  String toString() => 'SearchFormUninitialized';
}

class SearchFormChanged extends SearchFormState {
  final String keyword;

  SearchFormChanged({this.keyword}) : super([keyword]);

  @override
  String toString() => 'SearchFormChanged';
}
