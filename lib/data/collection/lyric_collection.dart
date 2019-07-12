import 'package:liriku/data/model/lyric.dart';

class LyricCollection {
  final List<Lyric> lyrics;
  final int page;
  final int perPage;

  LyricCollection(this.lyrics, this.page, this.perPage);
}
