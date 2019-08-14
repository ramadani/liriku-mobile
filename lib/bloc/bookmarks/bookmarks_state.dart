import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class BookmarksState extends Equatable {
  BookmarksState([List props = const []]) : super(props);
}

class BookmarksUninitialized extends BookmarksState {
  @override
  String toString() => 'BookmarksUninitialized';
}

class BookmarksLoading extends BookmarksState {
  @override
  String toString() => 'BookmarksLoading';
}

class BookmarksLoaded extends BookmarksState {
  final int page;
  final int perPage;
  final String keyword;
  final List<Lyric> lyrics;
  final bool hasMorePages;
  final bool fetchingMore;
  final bool adRepeatedly;
  final int adIndex;

  BookmarksLoaded({
    this.page,
    this.perPage,
    this.keyword,
    this.lyrics,
    this.hasMorePages = false,
    this.fetchingMore = false,
    this.adRepeatedly = false,
    this.adIndex = 0,
  }) : super([
          page,
          perPage,
          keyword,
          lyrics,
          hasMorePages,
          fetchingMore,
          adRepeatedly,
          adIndex,
        ]);

  @override
  String toString() =>
      'BookmarksLoaded { page: $page, perPage: $perPage, keyword: $keyword, lyricSize: ${lyrics.length}, hasMorePage: $hasMorePages, fetchingMore: $fetchingMore }';

  BookmarksLoaded setFetchingMore() {
    return BookmarksLoaded(
      page: this.page,
      perPage: this.perPage,
      keyword: this.keyword,
      lyrics: this.lyrics,
      hasMorePages: this.hasMorePages,
      fetchingMore: true,
      adRepeatedly: this.adRepeatedly,
      adIndex: this.adIndex,
    );
  }

  BookmarksLoaded fetchedMore(
      {int page, List<Lyric> newLyrics, bool hasMorePages = false}) {
    return BookmarksLoaded(
      page: page,
      perPage: this.perPage,
      keyword: this.keyword,
      lyrics: newLyrics.length > 0 ? this.lyrics + newLyrics : this.lyrics,
      hasMorePages: hasMorePages,
      fetchingMore: false,
      adRepeatedly: this.adRepeatedly,
      adIndex: this.adIndex,
    );
  }
}

class BookmarksEmpty extends BookmarksState {
  @override
  String toString() => 'BookmarksEmpty';
}

class BookmarksError extends BookmarksState {
  @override
  String toString() => 'BookmarksError';
}
