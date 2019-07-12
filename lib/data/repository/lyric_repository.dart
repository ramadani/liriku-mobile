import 'package:liriku/data/model/lyric.dart';

abstract class LyricRepository {
  Future<bool> syncTopLyric({int limit = 10});

  Future<List<Lyric>> getTopLyric({int limit = 10});
}
