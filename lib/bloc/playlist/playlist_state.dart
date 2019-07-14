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

  PlaylistLoaded({this.artistLyrics}) : super([artistLyrics]);

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
      'PlaylistLoaded { artist: ${artist.name}, lyric_size: ${lyrics.length} }';

  void updateBookmark(String id, bool bookmarked) {
    final index = lyrics.indexWhere((Lyric it) => it.id == id);
    if (index >= 0) {
      final lyric = lyrics[index];
      lyrics[index] = Lyric(
        id: lyric.id,
        title: lyric.title,
        content: lyric.content,
        coverUrl: lyric.coverUrl,
        bookmarked: bookmarked,
        readCount: lyric.readCount,
        artistId: lyric.artistId,
        createdAt: lyric.createdAt,
        updatedAt: lyric.updatedAt,
      );
    }
  }
}

class PlaylistError extends PlaylistState {
  @override
  String toString() => 'PlaylistError';
}
