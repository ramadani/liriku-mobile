import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class RecentlyReadState extends Equatable {
  RecentlyReadState([List props = const []]) : super(props);
}

class RecentlyReadUninitialized extends RecentlyReadState {
  @override
  String toString() => 'RecentlyReadUninitialized';
}

class RecentlyReadLoading extends RecentlyReadState {
  @override
  String toString() => 'RecentlyReadLoading';
}

class RecentlyReadLoaded extends RecentlyReadState {
  final List<Lyric> lyrics;
  final bool adRepeatedly;
  final int adIndex;

  RecentlyReadLoaded({
    this.lyrics,
    this.adRepeatedly = false,
    this.adIndex = 0,
  }) : super([lyrics, adRepeatedly, adIndex]);

  @override
  String toString() => 'RecentlyReadLoaded { lyricSize: ${lyrics.length} }';
}

class RecentlyReadEmpty extends RecentlyReadState {
  @override
  String toString() => 'RecentlyReadEmpty';
}

class RecentlyReadError extends RecentlyReadState {
  @override
  String toString() => 'RecentlyReadError';
}
