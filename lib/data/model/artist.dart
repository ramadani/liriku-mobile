import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/lyric.dart';

class Artist extends Equatable {
  final String id;
  final String name;
  final String coverUrl;
  final String collectionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Artist({
    this.id,
    this.name,
    this.coverUrl,
    this.collectionId,
    this.createdAt,
    this.updatedAt,
  }) : super([id, name, coverUrl, collectionId, createdAt, updatedAt]);
}

class ArtistLyrics extends Equatable {
  final String id;
  final String name;
  final String coverUrl;
  final String collectionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Lyric> lyrics;

  ArtistLyrics({
    this.id,
    this.name,
    this.coverUrl,
    this.collectionId,
    this.createdAt,
    this.updatedAt,
    this.lyrics,
  }) : super([id, name, coverUrl, collectionId, createdAt, updatedAt, lyrics]);

  ArtistLyrics copyWith({List<Lyric> lyrics}) {
    return ArtistLyrics(
      id: this.id,
      name: this.name,
      coverUrl: this.coverUrl,
      collectionId: this.collectionId,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      lyrics: lyrics,
    );
  }
}
