import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/artist_cache_provider.dart';
import 'package:liriku/data/provider/bookmarkable_provider.dart';
import 'package:liriku/data/provider/lyric_cache_provider.dart';
import 'package:liriku/data/provider/lyric_provider.dart';
import 'package:liriku/data/provider/top_rated_provider.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricRepositoryConcrete implements LyricRepository {
  final ArtistCacheProvider _artistCacheProvider;
  final LyricProvider _lyricProvider;
  final LyricCacheProvider _lyricCacheProvider;
  final TopRatedProvider _topRatedProvider;
  final BookmarkableProvider _bookmarkableProvider;

  LyricRepositoryConcrete(this._lyricProvider,
      this._lyricCacheProvider,
      this._artistCacheProvider,
      this._topRatedProvider,
      this._bookmarkableProvider,);

  @override
  Future<LyricCollection> paginate(
      {int page = 1, int perPage = 10, String search = ''}) async {
    final cacheResult =
    await _lyricCacheProvider.fetch(page, perPage, search: search);

    if (cacheResult.lyrics.length > 0) {
      return cacheResult;
    }

    final result = await _lyricProvider.fetch(page, perPage, search: search);
    print('dari api provider ${result.lyrics.length}');
//    await Future.forEach(result.lyrics, (Lyric lyric) async {
//      await _lyricCacheProvider.save(lyric, lyric.artistId);
//    });
    return result;
  }

  @override
  Future<List<Lyric>> getTopLyric({int limit = 10}) async {
    final List<String> listOfId =
    await _topRatedProvider.findAllByType('LYRIC');
    final lyrics = await _lyricCacheProvider.findWhereInId(listOfId);
    final List<LyricArtist> results = List();

    await Future.forEach(lyrics, (Lyric it) async {
      final artist = await _artistCacheProvider.detail(it.artistId);
      results.add(LyricArtist(
        id: it.id,
        title: it.title,
        coverUrl: it.coverUrl,
        content: it.content,
        readCount: it.readCount,
        bookmarked: it.bookmarked,
        createdAt: it.createdAt,
        updatedAt: it.updatedAt,
        artist: artist,
      ));
    });

    return results;
  }

  @override
  Future<bool> syncTopLyric({int limit = 10}) async {
    final lyrics = await _lyricProvider.topNew(limit);
    final List<String> listOfId = lyrics.map((it) => it.id).toList();

    await _topRatedProvider.deleteAllByType('LYRIC');
    await _topRatedProvider.insertAllByType(listOfId, 'LYRIC');
    await Future.forEach(lyrics, (Lyric it) async {
      if (it is LyricArtist) {
        await _lyricCacheProvider.save(it, it.artist.id);
      }
    });

    return true;
  }

  @override
  Future<LyricArtist> getDetail(String id) async {
    final lyric = await _lyricCacheProvider.detail(id);
    final artist = await _artistCacheProvider.detail(lyric.artistId);

    return LyricArtist(
      id: lyric.id,
      title: lyric.title,
      content: lyric.content,
      coverUrl: lyric.coverUrl,
      bookmarked: lyric.bookmarked,
      readCount: lyric.readCount,
      createdAt: lyric.createdAt,
      updatedAt: lyric.updatedAt,
      artist: artist,
    );
  }

  @override
  Future<bool> setBookmark(String id, bool bookmarked) async {
    await _lyricCacheProvider.setBookmark(id, bookmarked);

    try {
      if (bookmarked) {
        await _bookmarkableProvider.insert(id, 'LYRIC');
      } else {
        await _bookmarkableProvider.delete(id, 'LYRIC');
      }
    } catch (e) {}

    return true;
  }
}
