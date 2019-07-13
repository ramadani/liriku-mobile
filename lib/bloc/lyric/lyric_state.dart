import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/lyric.dart';

abstract class LyricState extends Equatable {
  LyricState([List props = const []]) : super(props);
}

class LyricLoading extends LyricState {
  @override
  String toString() => 'LyricLoading';
}

class LyricLoaded extends LyricState {
  final LyricArtist lyric;

  LyricLoaded({this.lyric}) : super([lyric]);

  @override
  String toString() =>
      'LyricLoaded { lyric: ${lyric.title}, artist: ${lyric.artist.name} }';
}

class LyricError extends LyricState {
  @override
  String toString() => 'LyricError';
}
