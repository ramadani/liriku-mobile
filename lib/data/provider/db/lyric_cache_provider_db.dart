import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/provider/lyric_cache_provider.dart';
import 'package:sqflite/sqflite.dart';

class LyricCacheProviderDb implements LyricCacheProvider {
  final Database _db;

  LyricCacheProviderDb(this._db);

  @override
  Future<LyricCollection> fetch(int page, int perPage,
      {String search = ''}) async {
    String searchLike = '';
    if (search != '') {
      searchLike = "WHERE title LIKE '%$search%'";
    }

    final offset = (page - 1) * perPage;
    final sql = 'SELECT id, title, cover_url, content, bookmarked, read_count, '
        'artist_id, created_at, updated_at FROM lyrics '
        '$searchLike LIMIT ?,?';
    final rows = await _db.rawQuery(sql, [offset, perPage]);
    final List<Lyric> lyrics = List();

    rows.toList().forEach((raw) {
      lyrics.add(_lyricMapper(raw));
    });

    return LyricCollection(lyrics, page, perPage);
  }

  @override
  Future<List<Lyric>> findByArtistId(String artistId) async {
    final sql = 'SELECT id, title, cover_url, content, bookmarked, read_count, '
        'artist_id, created_at, updated_at FROM lyrics WHERE artist_id = ?';
    final rows = await _db.rawQuery(sql, [artistId]);
    final List<Lyric> results = List();

    if (rows.isNotEmpty) {
      rows.toList().forEach((raw) {
        results.add(_lyricMapper(raw));
      });
    }

    return results;
  }

  @override
  Future<List<Lyric>> findWhereInId(List<String> listOfId) async {
    final args = listOfId.map((id) => '?').toList().join(', ');
    final sql = 'SELECT id, title, cover_url, content, bookmarked, read_count, '
        'artist_id, created_at, updated_at FROM lyrics WHERE id IN ($args)';
    final rows = await _db.rawQuery(sql, listOfId);
    final List<Lyric> results = List();

    if (rows.isNotEmpty) {
      rows.toList().forEach((raw) {
        results.add(_lyricMapper(raw));
      });
    }

    return results;
  }

  @override
  Future<Lyric> save(Lyric lyric, String artistId) async {
    try {
      final countSql = 'SELECT COUNT(id) as total FROM lyrics WHERE id = ?';
      final countRows = await _db.rawQuery(countSql, [lyric.id]);

      if (countRows.isNotEmpty && countRows[0]['total'] > 0) {
        // update
        final updateSql = 'UPDATE lyrics '
            'SET title = ?, cover_url = ?, content = ?, '
            'read_count = ?, updated_at = ? '
            'WHERE id = ?';
        await _db.rawUpdate(updateSql, [
          lyric.title,
          lyric.coverUrl,
          lyric.content,
          lyric.readCount,
          DateTime
              .now()
              .millisecondsSinceEpoch,
          lyric.id,
        ]);
      } else {
        // insert
        final insertSql = 'INSERT INTO lyrics (id, title, cover_url, content, '
            'read_count, bookmarked, artist_id, created_at, updated_at) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
        await _db.rawInsert(insertSql, [
          lyric.id,
          lyric.title,
          lyric.coverUrl,
          lyric.content,
          lyric.readCount,
          0,
          artistId,
          lyric.createdAt.millisecondsSinceEpoch,
          DateTime
              .now()
              .millisecondsSinceEpoch,
        ]);
      }

      return lyric;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Lyric> detail(String id) async {
    final sql = 'SELECT id, title, cover_url, content, bookmarked, read_count, '
        'artist_id, created_at, updated_at FROM lyrics WHERE id = ?';
    final rows = await _db.rawQuery(sql, [id]);

    if (rows.isEmpty) {
      throw Exception('Lyric by id $id is not found');
    }

    return _lyricMapper(rows[0]);
  }

  Lyric _lyricMapper(dynamic raw) {
    return Lyric(
      id: raw['id'],
      title: raw['title'],
      coverUrl: raw['cover_url'],
      readCount: raw['read_count'] as num,
      content: raw['content'],
      bookmarked: raw['bookmarked'] as num == 1,
      artistId: raw['artist_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(raw['created_at'] as num),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(raw['updated_at'] as num),
    );
  }

  @override
  Future<bool> setBookmark(String id, bool bookmarked) async {
    final sql = 'UPDATE lyrics SET bookmarked = ? WHERE id = ?';
    await _db.rawUpdate(sql, [bookmarked ? 1 : 0, id]);
    return true;
  }
}
