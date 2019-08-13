import 'package:equatable/equatable.dart';

abstract class LyricEvent extends Equatable {
  LyricEvent([List props = const []]) : super(props);
}

class GetLyric extends LyricEvent {
  final String id;

  GetLyric({this.id}) : super([id]);

  @override
  String toString() => 'GetLyric by id $id';
}
