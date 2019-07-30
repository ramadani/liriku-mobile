import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class LyricListState extends Equatable {
  LyricListState([List props = const []]) : super(props);
}

class LyricListUninitialized extends LyricListState {
  @override
  String toString() => 'LyricListUninitialized';
}

class LyricListLoading extends LyricListState {
  @override
  String toString() => 'LyricListLoading';
}

class LyricListLoaded extends LyricListState {
  final int page;
  final int perPage;
  final String keyword;
  final List<Lyric> lyrics;
  final bool hasMorePages;

  LyricListLoaded({
    this.page,
    this.perPage,
    this.keyword,
    this.lyrics,
    this.hasMorePages,
  }) : super([page, perPage, keyword, lyrics, hasMorePages]);

  @override
  String toString() => 'LyricListLoaded { page: $page, '
      'perPage: $perPage, keyword: $keyword, lyricSize: ${lyrics
      .length}, hasMorePage: $hasMorePages }';
}

class LyricListLoadingMore extends LyricListState {
  final int page;
  final int perPage;
  final String keyword;

  LyricListLoadingMore({this.page, this.perPage, this.keyword})
      : super([page, perPage, keyword]);

  @override
  String toString() =>
      'LyricListLoadingMore { page: $page, perPage: $perPage, keyword: $keyword }';
}

class LyricListEmpty extends LyricListState {
  @override
  String toString() => 'LyricListEmpty';
}

class LyricListError extends LyricListState {
  @override
  String toString() => 'LyricListError';
}
