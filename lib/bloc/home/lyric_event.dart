import 'package:equatable/equatable.dart';

abstract class LyricEvent extends Equatable {
  LyricEvent([List props = const []]) : super(props);
}

class FetchTopLyric extends LyricEvent {
  @override
  String toString() => 'FetchTopLyric';
}
