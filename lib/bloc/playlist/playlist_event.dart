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
