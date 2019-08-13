import 'package:liriku/data/model/artist.dart';

class ArtistCollection {
  final List<Artist> artists;
  final int page;
  final int perPage;

  ArtistCollection(this.artists, this.page, this.perPage);
}
