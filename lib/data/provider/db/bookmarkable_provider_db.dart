import 'package:liriku/data/provider/bookmarkable_provider.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkableProviderDb extends BookmarkableProvider {
  final Database _db;

  BookmarkableProviderDb(this._db);

  @override
  Future<List<String>> findIn(
      List<String> listOfBookmarkableId, String bookmarkableType) async {
    final List<String> results = List();
    final argsIn = listOfBookmarkableId.map((_) => '?').join(', ');
    final sql = 'SELECT id, bookmarkable_id, bookmarkable_type FROM '
        'bookmarkables WHERE bookmarkable_id IN ($argsIn}) '
        'AND bookmarkable_type = ?';
    final args = listOfBookmarkableId;
    args.add(bookmarkableType);

    final rows = await _db.rawQuery(sql, args);

    if (rows.isNotEmpty) {
      rows.toList().map((raw) {
        results.add(raw['bookmarkable_id']);
      });
    }

    return null;
  }

  @override
  Future<bool> insert(String bookmarkableId, String bookmarkableType) async {
    final sql = 'INSERT INTO bookmarkables (bookmarkable_id, '
        'bookmarkable_type, created_at, updated_at) VALUES (?, ?, ?, ?)';
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.rawInsert(sql, [bookmarkableId, bookmarkableType, now, now]);

    return true;
  }

  @override
  Future<bool> delete(String bookmarkableId, String bookmarkableType) async {
    final sql = 'DELETE FROM bookmarkables WHERE bookmarkable_id = ? '
        'AND bookmarkable_type = ?';
    await _db.rawDelete(sql, [bookmarkableId, bookmarkableType]);

    return true;
  }
}
