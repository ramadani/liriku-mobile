import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class LyricCacheProvider {
  Future<LyricCollection> fetch(int page, int perPage, {String search = ''});

  Future<LyricCollection> fetchBookmarks(int page, int perPage,
      {String search = ''});

  Future<List<Lyric>> fetchUpdatedLastSeen({int limit = 100});

  Future<List<Lyric>> findWhereInId(List<String> listOfId);

  Future<List<Lyric>> findByArtistId(String artistId);

  Future<Lyric> save(Lyric lyric, String artistId);

  Future<Lyric> detail(String id);

  Future<bool> read(String id);

  Future<bool> setBookmark(String id, bool bookmarked);
}
