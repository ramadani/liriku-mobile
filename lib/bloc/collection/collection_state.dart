import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/artist.dart';

abstract class CollectionState extends Equatable {
  CollectionState([List props = const []]) : super(props);
}

class CollectionUninitialized extends CollectionState {
  @override
  String toString() => 'CollectionUninitialized';
}

class CollectionLoading extends CollectionState {
  @override
  String toString() => 'CollectionLoading';
}

class CollectionLoaded extends CollectionState {
  final String id;
  final List<Artist> artists;
  final int page;
  final int perPage;
  final String keyword;
  final bool hasMorePages;
  final bool fetchingMore;
  final bool adRepeatedly;
  final int adIndex;

  CollectionLoaded({
    this.id,
    this.artists,
    this.page,
    this.perPage,
    this.keyword = '',
    this.hasMorePages = false,
    this.fetchingMore = false,
    this.adRepeatedly = false,
    this.adIndex = 0,
  }) : super([
          id,
          artists,
          page,
          perPage,
          keyword,
          hasMorePages,
          fetchingMore,
        ]);

  @override
  String toString() =>
      'CollectionLoaded { id: $id, artistSize: ${artists.length}, page: $page, perPage: $perPage, keyword: $keyword, hasMorePages: $hasMorePages, fetchingMore: $fetchingMore }';

  CollectionLoaded setFetchingMore() {
    return CollectionLoaded(
      id: this.id,
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

  CollectionLoaded fetchedMore(
      {int page, List<Artist> newArtists, bool hasMorePages = false}) {
    return CollectionLoaded(
      id: this.id,
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

class CollectionEmpty extends CollectionState {
  @override
  String toString() => 'CollectionEmpty';
}

class CollectionError extends CollectionState {
  @override
  String toString() => 'CollectionError';
}
