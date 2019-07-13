import 'package:liriku/data/model/artist.dart';

abstract class ArtistRepository {
  Future<bool> syncTopArtist({int limit = 10});

  Future<List<Artist>> getTopArtist({int limit = 10});

  Future<ArtistLyrics> syncAndGetArtistDetail(String id);

  Future<ArtistLyrics> getArtistDetail(String id);
}
