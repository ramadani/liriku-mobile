import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/artist_cache_provider.dart';
import 'package:liriku/data/provider/lyric_cache_provider.dart';
import 'package:liriku/data/provider/lyric_provider.dart';
import 'package:liriku/data/provider/top_rated_provider.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricRepositoryConcrete implements LyricRepository {
  final ArtistCacheProvider _artistCacheProvider;
  final LyricProvider _lyricProvider;
  final LyricCacheProvider _lyricCacheProvider;
  final TopRatedProvider _topRatedProvider;

  LyricRepositoryConcrete(this._lyricProvider,
      this._lyricCacheProvider,
      this._artistCacheProvider,
      this._topRatedProvider,);

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
}
