import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/artist_cache_provider.dart';
import 'package:liriku/data/provider/artist_provider.dart';
import 'package:liriku/data/provider/lyric_cache_provider.dart';
import 'package:liriku/data/provider/top_rated_provider.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class ArtistRepositoryConcrete implements ArtistRepository {
  final ArtistProvider _artistProvider;
  final ArtistCacheProvider _artistCacheProvider;
  final LyricCacheProvider _lyricCacheProvider;
  final TopRatedProvider _topRatedProvider;

  ArtistRepositoryConcrete(
    this._artistProvider,
    this._artistCacheProvider,
      this._lyricCacheProvider,
    this._topRatedProvider,
  );

  @override
  Future<List<Artist>> getTopArtist({int limit = 10}) async {
    final List<String> listOfId =
    await _topRatedProvider.findAllByType('ARTIST');
    final results = await _artistCacheProvider.findWhereInId(listOfId);

    return results;
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

  @override
  Future<ArtistLyrics> syncAndGetArtistDetail(String id) async {
    final result = await _artistProvider.detail(id);
    final artist = Artist(
      id: result.id,
      name: result.name,
      coverUrl: result.coverUrl,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
    );
    await _artistCacheProvider.save(artist);
    await Future.forEach(result.lyrics, (Lyric lyric) async {
      await _lyricCacheProvider.save(lyric, artist.id);
    });

    return await getArtistDetail(id);
  }

  @override
  Future<ArtistLyrics> getArtistDetail(String id) async {
    final artist = await _artistCacheProvider.detail(id);
    final lyrics = await _lyricCacheProvider.findByArtistId(id);

    return ArtistLyrics(
      id: artist.id,
      name: artist.name,
      coverUrl: artist.coverUrl,
      createdAt: artist.createdAt,
      updatedAt: artist.updatedAt,
      lyrics: lyrics,
    );
  }
}
