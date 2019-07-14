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
  final String artistId;

  Lyric({
    this.id,
    this.title,
    this.coverUrl,
    this.content,
    this.readCount,
    this.createdAt,
    this.updatedAt,
    this.bookmarked,
    this.artistId,
  }) : super([
    id,
    title,
    coverUrl,
    content,
    readCount,
    createdAt,
    updatedAt,
    bookmarked,
    artistId,
  ]);

  Lyric copyWith({bool bookmarked = false}) {
    return Lyric(
      id: this.id,
      title: this.title,
      coverUrl: this.coverUrl,
      content: this.content,
      readCount: this.readCount,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      bookmarked: bookmarked,
      artistId: this.artistId,
    );
  }
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
    artistId: artist.id,
        );

  LyricArtist copyWith({bool bookmarked = false}) {
    return LyricArtist(
      id: this.id,
      title: this.title,
      coverUrl: this.coverUrl,
      content: this.content,
      readCount: this.readCount,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      bookmarked: bookmarked,
      artist: this.artist,
    );
  }
}
