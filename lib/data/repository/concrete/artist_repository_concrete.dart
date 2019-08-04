import 'package:liriku/data/collection/artist_collection.dart';
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
  Future<ArtistCollection> paginate({
    int page = 1,
    int perPage = 10,
    String search = '',
    String collection = '',
  }) async {
    final cacheResult = await _artistCacheProvider.fetch(page, perPage,
        search: search, collection: collection);

    if (cacheResult.artists.length >= 3) {
      return cacheResult;
    }

    final result = await _artistProvider.fetch(page, perPage,
        search: search, collection: collection);

    await Future.forEach(result.artists, (Artist it) async {
      await _artistCacheProvider.save(it);
    });

    return result;
  }

  @override
  Future<bool> save(Artist artist) async {
    await _artistCacheProvider.save(artist);
    return true;
  }

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
  Future<bool> syncArtist(String id) async {
    await _syncArtist(id);

    return true;
  }

  Future<bool> syncLyrics(String artistId) async {
    final lyrics = await _artistProvider.lyrics(artistId);
    await Future.forEach(lyrics, (Lyric it) async {
      await _lyricCacheProvider.save(it, artistId);
    });

    return true;
  }

  @override
  Future<Artist> getArtist(String id) async {
    try {
      final result = await _artistCacheProvider.detail(id);
      return result;
    } catch (e) {
      await _syncArtist(id);

      final result = await _artistCacheProvider.detail(id);
      return result;
    }
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

  Future<void> _syncArtist(String id) async {
    final result = await _artistProvider.detail(id);
    final artist = Artist(
      id: result.id,
      name: result.name,
      coverUrl: result.coverUrl,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
    );
    await _artistCacheProvider.save(artist);
  }
}
