import 'package:equatable/equatable.dart';

abstract class BookmarkState extends Equatable {
  BookmarkState([List props = const []]) : super(props);
}

class BookmarkUninitialized extends BookmarkState {
  @override
  String toString() => 'BookmarkUninitialized';
}

class BookmarkInitialized extends BookmarkState {
  final String id;
  final bool bookmarked;

  BookmarkInitialized({this.id, this.bookmarked}) : super([id, bookmarked]);

  @override
  String toString() =>
      'BookmarkInitialized { id: $id, bookmarked: $bookmarked }';
}

class BookmarkChanged extends BookmarkState {
  final String id;
  final bool bookmarked;

  BookmarkChanged({this.id, this.bookmarked}) : super([id, bookmarked]);

  @override
  String toString() => 'BookmarkChanged { id: $id, bookmarked: $bookmarked }';
}

class BookmarkError extends BookmarkState {
  @override
  String toString() => 'BookmarkError';
}
