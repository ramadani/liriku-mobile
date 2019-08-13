import 'package:equatable/equatable.dart';

abstract class LyricEvent extends Equatable {
  LyricEvent([List props = const []]) : super(props);
}

class FetchTopLyric extends LyricEvent {
  @override
  String toString() => 'FetchTopLyric';
}

class ChangeBookmarkInLyrics extends LyricEvent {
  final String lyricId;
  final bool bookmarked;

  ChangeBookmarkInLyrics({this.lyricId, this.bookmarked})
      : super([lyricId, bookmarked]);

  @override
  String toString() =>
      'ChangeBookmarkInLyrics { lyricId: $lyricId, bookmarked: $bookmarked }';
}
