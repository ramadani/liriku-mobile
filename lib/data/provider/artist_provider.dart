import 'package:liriku/data/collection/artist_collection.dart';
import 'package:liriku/data/model/artist.dart';

abstract class ArtistProvider {
  Future<ArtistCollection> fetch(int page, int perPage, {String search = ""});

  Future<List<Artist>> topByNewLyric(int limit);

  Future<ArtistLyrics> detail(String id);
}
