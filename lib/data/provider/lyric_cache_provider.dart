import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class LyricCacheProvider {
  Future<LyricCollection> fetch(int page, int perPage, {String search = ""});

  Future<List<Lyric>> topNew(int limit);

  Future<Lyric> save(Lyric lyric);

  Future<bool> delete(String id);

  Future<Lyric> detail(String id);
}
