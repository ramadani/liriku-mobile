import 'package:equatable/equatable.dart';

import 'artist.dart';

class Lyric extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final String content;
  final int readCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool bookmarked;

  Lyric({
    this.id,
    this.title,
    this.coverUrl,
    this.content,
    this.readCount,
    this.createdAt,
    this.updatedAt,
    this.bookmarked,
  }) : super([
    id,
    title,
    coverUrl,
    content,
    readCount,
    createdAt,
    updatedAt,
    bookmarked,
  ]);
}

class LyricArtist extends Lyric {
  final Artist artist;

  LyricArtist({
    String id,
    String title,
    String coverUrl,
    String content,
    int readCount,
    DateTime createdAt,
    DateTime updatedAt,
    bool bookmarked,
    this.artist,
  }) : super(
          id: id,
          title: title,
          coverUrl: coverUrl,
    content: content,
          readCount: readCount,
    createdAt: createdAt,
    updatedAt: updatedAt,
          bookmarked: bookmarked,
        );
}
