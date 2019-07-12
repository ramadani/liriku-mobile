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
        rows.map((raw) => raw['top_rated_id']).toList();

    return results;
  }

  @override
  Future<List<String>> insertAllByType(
      List<String> listOfId, String type) async {
    for (var i = 0; i < listOfId.length; i++) {
      final sql = 'INSERT INTO top_rated '
          '(top_rated_id, top_rated_type, ranked) VALUES (?, ?, ?)';
      await _db.rawInsert(sql, [listOfId[0], type, i + 1]);
    }

    return listOfId;
  }

  @override
  Future<bool> deleteAllByType(String type) async {
    final sql = 'DELETE FROM top_rated WHERE top_rated_type = ?';
    await _db.rawDelete(sql, [type]);
    return true;
  }
}
