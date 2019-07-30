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

  ArtistListLoaded({this.page, this.perPage, this.keyword, this.artists})
      : super([page, perPage, keyword, artists]);

  @override
  String toString() => 'ArtistListLoaded { page: $page, '
      'perPage: $perPage, keyword: $keyword, artistSize: ${artists.length} }';
}

class ArtistListEmpty extends ArtistListState {
  @override
  String toString() => 'ArtistListEmpty';
}

class ArtistListError extends ArtistListState {
  @override
  String toString() => 'ArtistListError';
}
