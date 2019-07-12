import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/lyric_cache_provider.dart';
import 'package:liriku/data/provider/lyric_provider.dart';
import 'package:liriku/data/provider/top_rated_provider.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricRepositoryConcrete implements LyricRepository {
  final LyricProvider _lyricProvider;
  final LyricCacheProvider _lyricCacheProvider;
  final TopRatedProvider _topRatedProvider;

  LyricRepositoryConcrete(
      this._lyricProvider, this._lyricCacheProvider, this._topRatedProvider);

  @override
  Future<List<Lyric>> getTopLyric({int limit = 10}) async {
    final List<String> listOfId = await _topRatedProvider.findAllByType(
        'LYRIC');
    print('lirik ids $listOfId');
    final results = await _lyricCacheProvider.findWhereInId(listOfId);
    print('lyric results $results');

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
