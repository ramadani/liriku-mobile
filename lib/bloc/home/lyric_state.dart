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
  final List<Lyric> lyrics;

  LyricLoaded({this.lyrics}) : super([lyrics]);

  @override
  String toString() => 'LyricLoaded';
}

class LyricError extends LyricState {
  @override
  String toString() => 'LyricError';
}
