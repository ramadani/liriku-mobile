import 'package:liriku/data/collection/artist_collection.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/provider/artist_cache_provider.dart';

class ArtistCacheProviderDb implements ArtistCacheProvider {
  @override
  Future<ArtistCollection> fetch(int page, int perPage, {String search = ""}) {
    // TODO: implement fetch
    return null;
  }

  @override
  Future<List<Artist>> topByNewLyric(int limit) {
    // TODO: implement topByNewLyric
    return null;
  }

  @override
  Future<Artist> save(Artist artist) {
    // TODO: implement save
    return null;
  }

  @override
  Future<ArtistLyrics> detail(String id) {
    // TODO: implement detail
    return null;
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement delete
    return null;
  }
}
