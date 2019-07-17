import 'package:equatable/equatable.dart';

abstract class LyricListEvent extends Equatable {
  LyricListEvent([List props = const []]) : super(props);
}

class FetchLyricList extends LyricListEvent {
  final int page;
  final int perPage;
  final String keyword;

  FetchLyricList({this.page = 1, this.perPage = 50, this.keyword = ''})
      : super([page, perPage, keyword]);

  @override
  String toString() =>
      'FetchLyricList { page: $page, perPage: $perPage, keyword: $keyword }';
}

class ChangeBookmarkInList extends LyricListEvent {
  final String lyricId;
  final bool bookmarked;

  ChangeBookmarkInList({this.lyricId, this.bookmarked})
      : super([lyricId, bookmarked]);

  @override
  String toString() =>
      'ChangeBookmarkInList { lyricId: $lyricId, bookmarked: $bookmarked }';
}

class FetchMoreLyricList extends LyricListEvent {
  @override
  String toString() => 'FetchMoreLyricList';
}

class ResetLyricList extends LyricListEvent {
  @override
  String toString() => 'ResetLyricList';
}
