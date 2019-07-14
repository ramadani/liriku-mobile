import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class LyricCacheProvider {
  Future<LyricCollection> fetch(int page, int perPage, {String search = ""});

  Future<List<Lyric>> findWhereInId(List<String> listOfId);

  Future<List<Lyric>> findByArtistId(String artistId);

  Future<Lyric> save(Lyric lyric, String artistId);

  Future<Lyric> detail(String id);

  Future<bool> setBookmark(String id, bool bookmarked);
}
