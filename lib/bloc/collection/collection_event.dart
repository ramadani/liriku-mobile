import 'package:equatable/equatable.dart';

abstract class CollectionEvent extends Equatable {
  CollectionEvent([List props = const []]) : super(props);
}

class FetchCollection extends CollectionEvent {
  final String id;
  final int page;
  final int perPage;
  final String keyword;

  FetchCollection({
    this.id,
    this.page = 1,
    this.perPage = 50,
    this.keyword = '',
  }) : super([id, page, perPage, keyword]);

  @override
  String toString() =>
      'FetchCollection { id: $id, page: $page, perPage: $perPage, keyword: $keyword }';
}

class FetchMoreCollection extends CollectionEvent {
  @override
  String toString() => 'FetchMoreCollection';
}
