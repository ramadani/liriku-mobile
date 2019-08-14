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
  final bool fetchingMore;
  final bool adRepeatedly;
  final int adIndex;

  LyricListLoaded({
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
  String toString() => 'LyricListLoaded { page: $page, '
      'perPage: $perPage, keyword: $keyword, lyricSize: ${lyrics.length}, hasMorePage: $hasMorePages, fetchingMore: $fetchingMore }';

  LyricListLoaded setFetchingMore() {
    return LyricListLoaded(
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

  LyricListLoaded fetchedMore(
      {int page, List<Lyric> newLyrics, bool hasMorePages = false}) {
    return LyricListLoaded(
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

  LyricListLoaded updateLyrics(List<Lyric> lyrics) {
    return LyricListLoaded(
      page: this.page,
      perPage: this.perPage,
      keyword: this.keyword,
      lyrics: lyrics,
      hasMorePages: this.hasMorePages,
      fetchingMore: false,
      adRepeatedly: this.adRepeatedly,
      adIndex: this.adIndex,
    );
  }
}

class LyricListEmpty extends LyricListState {
  @override
  String toString() => 'LyricListEmpty';
}

class LyricListError extends LyricListState {
  @override
  String toString() => 'LyricListError';
}
