import 'package:equatable/equatable.dart';

abstract class ArtistListEvent extends Equatable {
  ArtistListEvent([List props = const []]) : super(props);
}

class FetchArtistList extends ArtistListEvent {
  final int page;
  final int perPage;
  final String keyword;

  FetchArtistList({this.page = 1, this.perPage = 15, this.keyword = ''})
      : super([page, perPage, keyword]);

  @override
  String toString() =>
      'FetchArtistList { page: $page, perPage: $perPage, keyword: $keyword }';
}

class FetchMoreArtistList extends ArtistListEvent {
  @override
  String toString() => 'FetchMoreArtistList';
}
