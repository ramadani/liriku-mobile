import 'package:equatable/equatable.dart';

abstract class CollectionEvent extends Equatable {
  CollectionEvent([List props = const []]) : super(props);
}

class FetchCollection extends CollectionEvent {
  final String id;
  final int page;
  final int perPage;

  FetchCollection({this.id, this.page = 1, this.perPage = 7})
      : super([id, page, perPage]);

  @override
  String toString() =>
      'FetchCollection { id: $id, page: $page, perPage: $perPage }';
}

class FetchMoreCollection extends CollectionEvent {
  @override
  String toString() => 'FetchMoreCollection';
}
