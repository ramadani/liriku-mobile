import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/bookmarkable_provider.dart';
import 'package:liriku/data/provider/lyric_cache_provider.dart';
import 'package:liriku/data/provider/lyric_provider.dart';
import 'package:liriku/data/provider/top_rated_provider.dart';
import 'package:liriku/data/repository/artist_repository.dart';
import 'package:liriku/data/repository/lyric_repository.dart';

class LyricRepositoryConcrete implements LyricRepository {
  final LyricProvider _lyricProvider;
  final LyricCacheProvider _lyricCacheProvider;
  final TopRatedProvider _topRatedProvider;
  final BookmarkableProvider _bookmarkableProvider;
  final ArtistRepository _artistRepository;

  LyricRepositoryConcrete(
    this._lyricProvider,
    this._lyricCacheProvider,
    this._topRatedProvider,
    this._bookmarkableProvider,
    this._artistRepository,
  );

  @override
  Future<LyricCollection> paginate(
      {int page = 1, int perPage = 10, String search = ''}) async {
    try {
      final cacheResult =
          await _lyricCacheProvider.fetch(page, perPage, search: search);

      if (cacheResult.lyrics.length >= 3) {
        final lyrics = await _getLyricArtists(cacheResult.lyrics);
        return cacheResult.copyWith(lyrics: lyrics);
      }

      final result = await _lyricProvider.fetch(page, perPage,
          search: search.toLowerCase());

      await Future.forEach(result.lyrics, (Lyric lyric) async {
        if (lyric is LyricArtist) {
          await _artistRepository.save(lyric.artist);
        }
        await _lyricCacheProvider.save(lyric, lyric.artistId);
      });

      return result;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<LyricCollection> paginateBookmarks(
      {int page = 1, int perPage = 10, String search = ''}) async {
    final result =
        await _lyricCacheProvider.fetchBookmarks(page, perPage, search: search);
    final lyrics = await _getLyricArtists(result.lyrics);

    return result.copyWith(lyrics: lyrics);
  }

  @override
  Future<List<Lyric>> getTopLyric({int limit = 10}) async {
    final List<String> listOfId =
        await _topRatedProvider.findAllByType('LYRIC');
    final lyrics = await _lyricCacheProvider.findWhereInId(listOfId);

    return await _getLyricArtists(lyrics);
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
  Future<List<Lyric>> getRecentlyRead({int limit = 100}) async {
    final result = await _lyricCacheProvider.fetchUpdatedLastSeen(limit: limit);

    return await _getLyricArtists(result);
  }

  @override
  Future<LyricArtist> getDetail(String id) async {
    final lyric = await _lyricCacheProvider.detail(id);
    final artist = await _artistRepository.getArtist(lyric.artistId);

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
  Future<bool> read(String id) async {
    try {
      await _lyricCacheProvider.read(id);
      await _lyricProvider.read(id);

      return true;
    } catch (e) {
      throw e;
    }
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

  Future<List<LyricArtist>> _getLyricArtists(List<Lyric> lyrics) async {
    final List<LyricArtist> results = List();

    await Future.forEach(lyrics, (Lyric it) async {
      final artist = await _artistRepository.getArtist(it.artistId);

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
}
