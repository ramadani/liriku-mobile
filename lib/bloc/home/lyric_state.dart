import 'dart:math';

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

  int get adIndex {
    final end = lyrics.length;
    final start = end - 3;
    if (start > 0) {
      final random = Random();
      final num = start + random.nextInt(end - start);
      return num - 1;
    }

    return end;
  }

  @override
  String toString() => 'LyricLoaded';
}

class LyricError extends LyricState {
  @override
  String toString() => 'LyricError';
}
