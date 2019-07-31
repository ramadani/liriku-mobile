import 'package:liriku/data/collection/artist_collection.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class ArtistProvider {
  Future<ArtistCollection> fetch(int page, int perPage, {String search = ""});

  Future<List<Artist>> topByNewLyric(int limit);

  Future<Artist> detail(String id);

  Future<List<Lyric>> lyrics(String id);
}
