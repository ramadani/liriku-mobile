import 'package:liriku/data/model/collection.dart';
import 'package:liriku/data/provider/collection_cache_provider.dart';
import 'package:sqflite/sqflite.dart';

class CollectionCacheProviderDb implements CollectionCacheProvider {
  final Database _db;

  CollectionCacheProviderDb(this._db);

  @override
  Future<List<Collection>> all() async {
    try {
      final sql =
          'SELECT id, label, createdAt FROM collections';
      final rows = await _db.rawQuery(sql);
      final List<Collection> results = List();

      rows.forEach((raw) {
        results.add(Collection(
          id: raw['id'],
          label: raw['label'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(raw['createdAt']),
        ));
      });

      return results;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> save(Collection collection) async {
    try {
      final sql = 'REPLACE INTO collections (id, label, createdAt, updatedAt) '
          'VALUES (?, ?, ?, ?)';
      await _db.rawInsert(sql, [
        collection.id,
        collection.label,
        collection.createdAt.millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
      ]);

      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<int> total() async {
    try {
      final sql = 'SELECT COUNT(id) as total FROM collections';
      final rows = await _db.rawQuery(sql);

      if (rows == null || rows.isEmpty) {
        return 0;
      }

      return rows[0]['total'] as num;
    } catch (e) {
      throw e;
    }
  }
}
