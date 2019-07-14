import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  BookmarkEvent([List props = const []]) : super(props);
}

class SetBookmark extends BookmarkEvent {
  final String id;
  final bool bookmarked;

  SetBookmark({this.id, this.bookmarked}) : super([id, bookmarked]);

  @override
  String toString() => 'SetBookmark { id: $id, bookmarked: $bookmarked }';
}

class BookmarkPressed extends BookmarkEvent {
  final String id;
  final bool bookmarked;

  BookmarkPressed({this.id, this.bookmarked}) : super([id, bookmarked]);

  @override
  String toString() => 'BookmarkPressed { id: $id, bookmarked: $bookmarked }';
}
