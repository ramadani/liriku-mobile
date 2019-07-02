import 'package:equatable/equatable.dart';

import 'artist.dart';

class Lyric extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final int readCount;
  final bool bookmarked;

  Lyric({
    this.id,
    this.title,
    this.coverUrl,
    this.readCount,
    this.bookmarked,
  }) : super([id, title, coverUrl, readCount, bookmarked]);
}

class LyricArtist extends Lyric {
  final Artist artist;

  LyricArtist({
    String id,
    String title,
    String coverUrl,
    int readCount,
    bool bookmarked,
    this.artist,
  }) : super(
          id: id,
          title: title,
          coverUrl: coverUrl,
          readCount: readCount,
          bookmarked: bookmarked,
        );
}
