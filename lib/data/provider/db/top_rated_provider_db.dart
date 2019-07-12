import 'package:liriku/data/provider/top_rated_provider.dart';
import 'package:sqflite/sqflite.dart';

class TopRatedProviderDb implements TopRatedProvider {
  final Database _db;

  TopRatedProviderDb(this._db);

  @override
  Future<List<String>> findAllByType(String type) async {
    final sql = 'SELECT top_rated_id FROM top_rated '
        'WHERE top_rated_type = ? ORDER BY ranked ASC';
    final rows = await _db.rawQuery(sql, [type]);
    final List<String> results =
    rows.map((raw) => raw['top_rated_id'].toString()).toList();

    return results;
  }

  @override
  Future<List<String>> insertAllByType(
      List<String> listOfId, String type) async {
    int ranked = 0;
    await Future.forEach(listOfId, (String id) async {
      final sql = 'INSERT INTO top_rated '
          '(top_rated_id, top_rated_type, ranked) VALUES (?, ?, ?)';
      await _db.rawInsert(sql, [id, type, ++ranked]);
    });

    return listOfId;
  }

  @override
  Future<bool> deleteAllByType(String type) async {
    final sql = 'DELETE FROM top_rated WHERE top_rated_type = ?';
    await _db.rawDelete(sql, [type]);
    return true;
  }
}
