import 'package:equatable/equatable.dart';

abstract class PlaylistEvent extends Equatable {
  PlaylistEvent([List props = const []]) : super(props);
}

class GetPlaylist extends PlaylistEvent {
  final String artistId;

  GetPlaylist({this.artistId}) : super([artistId]);

  @override
  String toString() => 'GetPlaylist by artist id $artistId';
}

class ChangeBookmarkInPlaylist extends PlaylistEvent {
  final String lyricId;
  final bool bookmarked;

  ChangeBookmarkInPlaylist({this.lyricId, this.bookmarked})
      : super([lyricId, bookmarked]);

  @override
  String toString() =>
      'ChangeBookmarkInPlaylist { lyricId: $lyricId, bookmarked: $bookmarked }';
}
