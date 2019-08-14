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
  final bool adRepeatedly;
  final int adIndex;

  ArtistListLoaded({
    this.page,
    this.perPage,
    this.keyword,
    this.artists,
    this.hasMorePages = false,
    this.fetchingMore = false,
    this.adRepeatedly = false,
    this.adIndex = 0,
  }) : super([
          page,
          perPage,
          keyword,
          artists,
          hasMorePages,
          fetchingMore,
          adRepeatedly,
          adIndex,
        ]);

  @override
  String toString() =>
      'ArtistListLoaded { page: $page, perPage: $perPage, keyword: $keyword, artistSize: ${artists.length}, hasMorePage: $hasMorePages, fetchingMore: $fetchingMore }';

  ArtistListLoaded setFetchingMore() {
    return ArtistListLoaded(
      page: this.page,
      perPage: this.perPage,
      keyword: this.keyword,
      artists: this.artists,
      hasMorePages: this.hasMorePages,
      fetchingMore: true,
      adRepeatedly: this.adRepeatedly,
      adIndex: this.adIndex,
    );
  }

  ArtistListLoaded fetchedMore(
      {int page, List<Artist> newArtists, bool hasMorePages = false}) {
    return ArtistListLoaded(
      page: page,
      perPage: this.perPage,
      keyword: this.keyword,
      artists: newArtists.length > 0 ? this.artists + newArtists : this.artists,
      hasMorePages: hasMorePages,
      fetchingMore: false,
      adRepeatedly: this.adRepeatedly,
      adIndex: this.adIndex,
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
