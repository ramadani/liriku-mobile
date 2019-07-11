import 'dart:core';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteProvider {
  Future<Database> open() async {
    return openDatabase(
      join(await getDatabasesPath(), 'liriku.db'),
      onCreate: (db, version) async {
        await db.execute(_createActivityTable());
        await db.execute(_createArtistTable());
        await db.execute(_createLyricTable());
        await db.execute(_createTopRatedTable());
      },
      version: 1,
    );
  }

  String _createActivityTable() {
    return 'CREATE TABLE activities(id INTEGER PRIMARY KEY, name TEXT, '
        'created_at INTEGER, updated_at INTEGER)';
  }

  String _createArtistTable() {
    return 'CREATE TABLE artists(id TEXT, name TEXT, cover_url TEXT, '
        'created_at INTEGER, updated_at INTEGER)';
  }

  String _createLyricTable() {
    return 'CREATE TABLE lyrics(id TEXT, title TEXT, cover_url TEXT, '
        'content TEXT, read_count INTEGER, artist_id TEXT, created_at INTEGER, '
        'updated_at INTEGER)';
  }

  String _createTopRatedTable() {
    return 'CREATE TABLE top_rated(id INTEGER PRIMARY KEY, top_rated_id TEXT, '
        'top_rated_type TEXT, metadata TEXT, ranked INTEGER)';
  }
}
