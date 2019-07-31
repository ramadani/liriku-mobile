import 'package:equatable/equatable.dart';

abstract class BookmarksEvent extends Equatable {
  BookmarksEvent([List props = const []]) : super(props);
}

class FetchBookmarks extends BookmarksEvent {
  final int page;
  final int perPage;
  final String keyword;

  FetchBookmarks({this.page = 1, this.perPage = 100, this.keyword = ''})
      : super([page, perPage, keyword]);

  @override
  String toString() =>
      'FetchBookmarks { page: $page, perPage: $perPage, keyword: $keyword }';
}

class FetchMoreBookmarks extends BookmarksEvent {
  @override
  String toString() => 'FetchMoreBookmarks';
}

class RemoveBookmarkInList extends BookmarksEvent {
  final String lyricId;
  final bool bookmarked;

  RemoveBookmarkInList({this.lyricId, this.bookmarked})
      : super([lyricId, bookmarked]);

  @override
  String toString() =>
      'RemoveBookmarkInList { lyricId: $lyricId, bookmarked: $bookmarked }';
}

class ResetBookmarks extends BookmarksEvent {
  @override
  String toString() => 'ResetBookmarks';
}
