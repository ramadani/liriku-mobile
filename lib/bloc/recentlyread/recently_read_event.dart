import 'package:equatable/equatable.dart';

abstract class RecentlyReadEvent extends Equatable {
  RecentlyReadEvent([List props = const []]) : super(props);
}

class FetchRecentlyRead extends RecentlyReadEvent {
  final int limit;

  FetchRecentlyRead({this.limit = 100}) : super([limit]);

  @override
  String toString() => 'FetchRecentlyRead { limit: $limit }';
}

class ChangeBookmarkInList extends RecentlyReadEvent {
  final String lyricId;
  final bool bookmarked;

  ChangeBookmarkInList({this.lyricId, this.bookmarked})
      : super([lyricId, bookmarked]);

  @override
  String toString() =>
      'ChangeBookmarkInList { lyricId: $lyricId, bookmarked: $bookmarked }';
}
