import 'dart:core';

import 'package:liriku/data/collection/lyric_collection.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class LyricRepository {
  Future<LyricCollection> paginate(
      {int page = 1, int perPage = 10, String search = ''});

  Future<LyricCollection> paginateBookmarks(
      {int page = 1, int perPage = 10, String search = ''});

  Future<bool> syncTopLyric({int limit = 10});

  Future<List<Lyric>> getTopLyric({int limit = 10});

  Future<List<Lyric>> getRecentlyRead({int limit = 100});

  Future<LyricArtist> getDetail(String id);

  Future<bool> setBookmark(String id, bool bookmarked);
}
