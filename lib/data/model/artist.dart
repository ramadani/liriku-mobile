import 'package:equatable/equatable.dart';
import 'package:liriku/widget/lyric_item.dart';

class Artist extends Equatable {
  final String id;
  final String name;
  final String coverUrl;

  Artist({this.id, this.name, this.coverUrl}) : super([id, name, coverUrl]);
}

class ArtistLyrics extends Equatable {
  final String id;
  final String name;
  final String coverUrl;
  final List<LyricItem> lyrics;

  ArtistLyrics({this.id, this.name, this.coverUrl, this.lyrics})
      : super([id, name, coverUrl, lyrics]);
}
