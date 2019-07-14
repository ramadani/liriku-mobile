import 'package:equatable/equatable.dart';

abstract class BookmarkState extends Equatable {
  BookmarkState([List props = const []]) : super(props);
}

class UnchangedBookmark extends BookmarkState {
  @override
  String toString() => 'UnchangedBookmark';
}

class ChangedBookmark extends BookmarkState {
  final String id;
  final bool bookmarked;

  ChangedBookmark({this.id, this.bookmarked}) : super([id, bookmarked]);

  @override
  String toString() => 'ChangedBookmark { id: $id, bookmarked: $bookmarked }';
}

class BookmarkError extends BookmarkState {
  @override
  String toString() => 'BookmarkError';
}
