import 'package:liriku/data/collection/artist_collection.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/provider/artist_cache_provider.dart';
import 'package:sqflite/sqflite.dart';

class ArtistCacheProviderDb implements ArtistCacheProvider {
  final Database _db;

  ArtistCacheProviderDb(this._db);

  @override
  Future<ArtistCollection> fetch(int page, int perPage,
      {String search = ""}) async {
    final offset = (page - 1) * perPage;
    final sql = 'SELECT id, name, cover_url, created_at, updated_at '
        'FROM artists LIMIT ?,?';
    final rows = await _db.rawQuery(sql, [offset, perPage]);
    final List<Artist> artists = List();

    if (rows.isNotEmpty) {
      rows.toList().forEach((raw) {
        artists.add(_artistMapper(raw));
      });
    }

    return ArtistCollection(artists, page, perPage);
  }

  @override
  Future<List<Artist>> findWhereInId(List<String> listOfId) async {
    final args = listOfId.map((id) => '?').toList().join(', ');
    final sql = 'SELECT id, name, cover_url, created_at, updated_at '
        'FROM artists WHERE id IN ($args)';
    final rows = await _db.rawQuery(sql, listOfId);
    final List<Artist> results = List();

    if (rows.isNotEmpty) {
      rows.toList().forEach((raw) {
        results.add(_artistMapper(raw));
      });
    }

    return results;
  }

  @override
  Future<Artist> save(Artist artist) async {
    final sql = 'REPLACE INTO artists (id, name, cover_url, created_at, '
        'updated_at) VALUES (?, ?, ?, ?, ?)';
    await _db.execute(sql, [
      artist.id,
      artist.name,
      artist.coverUrl,
      artist.createdAt.millisecondsSinceEpoch,
      DateTime
          .now()
          .millisecondsSinceEpoch,
    ]);

    return artist;
  }

  @override
  Future<Artist> detail(String id) async {
    final sql = 'SELECT id, name, cover_url, created_at, updated_at '
        'FROM artists WHERE id = ?';
    final rows = await _db.rawQuery(sql, [id]);

    if (rows.isEmpty) {
      throw Exception('Artist by id $id is not found');
    }

    return _artistMapper(rows[0]);
  }

  Artist _artistMapper(dynamic raw) {
    return Artist(
      id: raw['id'],
      name: raw['name'],
      coverUrl: raw['cover_url'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(raw['created_at'] as num),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(raw['updated_at'] as num),
    );
  }
}
