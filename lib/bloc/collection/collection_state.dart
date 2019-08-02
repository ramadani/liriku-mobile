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
  final bool hasMorePages;
  final bool fetchingMore;

  CollectionLoaded({
    this.id,
    this.artists,
    this.page,
    this.perPage,
    this.hasMorePages,
    this.fetchingMore,
  }) : super([
          id,
          artists,
          page,
          perPage,
          hasMorePages = false,
          fetchingMore = false,
        ]);

  @override
  String toString() =>
      'CollectionLoaded { id: $id, artistSize: ${artists.length}, page: $page, perPage: $perPage, hasMorePages: $hasMorePages, fetchingMore: $fetchingMore }';

  CollectionLoaded setFetchingMore() {
    return CollectionLoaded(
      id: this.id,
      page: this.page,
      perPage: this.perPage,
      artists: this.artists,
      hasMorePages: this.hasMorePages,
      fetchingMore: true,
    );
  }

  CollectionLoaded fetchedMore(
      {int page, List<Artist> newArtists, bool hasMorePages = false}) {
    return CollectionLoaded(
      id: this.id,
      page: page,
      perPage: this.perPage,
      artists: newArtists.length > 0 ? this.artists + newArtists : this.artists,
      hasMorePages: hasMorePages,
      fetchingMore: false,
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
