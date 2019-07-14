import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  BookmarkEvent([List props = const []]) : super(props);
}

class InitBookmark extends BookmarkEvent {
  final String id;
  final bool bookmarked;

  InitBookmark({this.id, this.bookmarked}) : super([id, bookmarked]);

  @override
  String toString() => 'InitBookmark { id: $id, bookmarked: $bookmarked }';
}

class BookmarkPressed extends BookmarkEvent {
  final String id;
  final bool bookmarked;

  BookmarkPressed({this.id, this.bookmarked}) : super([id, bookmarked]);

  @override
  String toString() => 'BookmarkPressed { id: $id, bookmarked: $bookmarked }';
}
