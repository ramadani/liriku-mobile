import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class PlaylistState extends Equatable {
  PlaylistState([List props = const []]) : super(props);
}

class PlaylistLoading extends PlaylistState {
  @override
  String toString() => 'PlaylistLoading';
}

class PlaylistLoaded extends PlaylistState {
  final ArtistLyrics artistLyrics;
  final bool adRepeatedly;
  final int adIndex;

  PlaylistLoaded({
    this.artistLyrics,
    this.adRepeatedly = false,
    this.adIndex,
  }) : super([artistLyrics]);

  Artist get artist {
    return Artist(
      id: artistLyrics.id,
      name: artistLyrics.name,
      coverUrl: artistLyrics.coverUrl,
      createdAt: artistLyrics.createdAt,
      updatedAt: artistLyrics.updatedAt,
    );
  }

  List<Lyric> get lyrics => artistLyrics.lyrics;

  @override
  String toString() =>
      'PlaylistLoaded { artist: ${artist.name}, lyricSize: ${lyrics.length}, adRepeatedly: $adRepeatedly, adIndex: $adIndex }';
}

class PlaylistError extends PlaylistState {
  @override
  String toString() => 'PlaylistError';
}
