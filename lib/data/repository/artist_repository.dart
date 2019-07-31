import 'package:liriku/data/collection/artist_collection.dart';
import 'package:liriku/data/model/artist.dart';

abstract class ArtistRepository {
  Future<ArtistCollection> paginate(
      {int page = 1, int perPage = 10, String search = ''});

  Future<bool> save(Artist artist);

  Future<bool> syncTopArtist({int limit = 10});

  Future<List<Artist>> getTopArtist({int limit = 10});

  Future<bool> syncArtist(String id);

  Future<bool> syncLyrics(String artistId);

  Future<Artist> getArtist(String id);

  Future<ArtistLyrics> getArtistDetail(String id);
}
