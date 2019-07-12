import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/provider/artist_cache_provider.dart';
import 'package:liriku/data/provider/artist_provider.dart';
import 'package:liriku/data/provider/top_rated_provider.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class ArtistRepositoryConcrete implements ArtistRepository {
  final ArtistProvider _artistProvider;
  final ArtistCacheProvider _artistCacheProvider;
  final TopRatedProvider _topRatedProvider;

  ArtistRepositoryConcrete(
    this._artistProvider,
    this._artistCacheProvider,
    this._topRatedProvider,
  );

  @override
  Future<List<Artist>> getTopArtist({int limit = 10}) async {
    final listOfId = await _topRatedProvider.findAllByType('ARTIST');

    return await _artistCacheProvider.findWhereInId(listOfId);
  }

  @override
  Future<bool> syncTopArtist({int limit = 10}) async {
    final artists = await _artistProvider.topByNewLyric(limit);
    final List<String> listOfId = artists.map((it) => it.id).toList();

    await _topRatedProvider.deleteAllByType('ARTIST');
    await _topRatedProvider.insertAllByType(listOfId, 'ARTIST');
    await Future.forEach(artists, (Artist it) async {
      await _artistCacheProvider.save(it);
    });

    return true;
  }
}
