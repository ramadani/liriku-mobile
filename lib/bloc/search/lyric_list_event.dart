import 'package:equatable/equatable.dart';

abstract class LyricListEvent extends Equatable {
  LyricListEvent([List props = const []]) : super(props);
}

class FetchLyricList extends LyricListEvent {
  final int page;
  final int perPage;
  final String keyword;

  FetchLyricList({this.page, this.perPage, this.keyword})
      : super([page, perPage, keyword]);

  @override
  String toString() =>
      'FetchLyricList { page: $page, perPage: $perPage, keyword: $keyword }';
}

class FetchMoreLyricList extends LyricListEvent {
  @override
  String toString() => 'FetchMoreLyricList';
}
