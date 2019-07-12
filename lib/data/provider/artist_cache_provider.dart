import 'package:liriku/data/collection/artist_collection.dart';
import 'package:liriku/data/model/artist.dart';

abstract class ArtistCacheProvider {
  Future<ArtistCollection> fetch(int page, int perPage, {String search = ""});

  Future<List<Artist>> findWhereInId(List<String> listOfId);

  Future<Artist> detail(String id);

  Future<Artist> save(Artist artist);
}
