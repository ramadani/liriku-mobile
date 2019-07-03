import 'package:equatable/equatable.dart';

import 'artist.dart';

class Lyric extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final String content;
  final int readCount;
  final bool bookmarked;

  Lyric({
    this.id,
    this.title,
    this.coverUrl,
    this.content,
    this.readCount,
    this.bookmarked,
  }) : super([id, title, coverUrl, content, readCount, bookmarked]);
}

class LyricArtist extends Lyric {
  final Artist artist;

  LyricArtist({
    String id,
    String title,
    String coverUrl,
    String content,
    int readCount,
    bool bookmarked,
    this.artist,
  }) : super(
          id: id,
          title: title,
          coverUrl: coverUrl,
    content: content,
          readCount: readCount,
          bookmarked: bookmarked,
        );
}
