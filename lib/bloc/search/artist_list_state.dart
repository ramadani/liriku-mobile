import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/artist.dart';

abstract class ArtistListState extends Equatable {
  ArtistListState([List props = const []]) : super(props);
}

class ArtistListUninitialized extends ArtistListState {
  @override
  String toString() => 'ArtistListUninitialized';
}

class ArtistListLoading extends ArtistListState {
  @override
  String toString() => 'ArtistListLoading';
}

class ArtistListLoaded extends ArtistListState {
  final int page;
  final int perPage;
  final String keyword;
  final List<Artist> artists;
  final bool hasMorePages;
  final bool fetchingMore;

  ArtistListLoaded({
    this.page,
    this.perPage,
    this.keyword,
    this.artists,
    this.hasMorePages = false,
    this.fetchingMore = false,
  }) : super([page, perPage, keyword, artists, hasMorePages, fetchingMore]);

  @override
  String toString() =>
      'ArtistListLoaded { page: $page, perPage: $perPage, keyword: $keyword, artistSize: ${artists
          .length}, hasMorePage: $hasMorePages, fetchingMore: $fetchingMore }';

  ArtistListLoaded setFetchingMore() {
    return ArtistListLoaded(
      page: this.page,
      perPage: this.perPage,
      keyword: this.keyword,
      artists: this.artists,
      hasMorePages: this.hasMorePages,
      fetchingMore: true,
    );
  }

  ArtistListLoaded fetchedMore(
      {List<Artist> newArtists, bool hasMorePages = false}) {
    return ArtistListLoaded(
      page: this.page,
      perPage: this.perPage,
      keyword: this.keyword,
      artists: newArtists.length > 0 ? this.artists + newArtists : this.artists,
      hasMorePages: this.hasMorePages,
      fetchingMore: false,
    );
  }
}

class ArtistListEmpty extends ArtistListState {
  @override
  String toString() => 'ArtistListEmpty';
}

class ArtistListError extends ArtistListState {
  @override
  String toString() => 'ArtistListError';
}
