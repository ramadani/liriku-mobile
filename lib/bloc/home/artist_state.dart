import 'package:equatable/equatable.dart';
import 'package:liriku/data/model/artist.dart';

abstract class ArtistState extends Equatable {
  ArtistState([List props = const []]) : super(props);
}

class ArtistLoading extends ArtistState {
  @override
  String toString() => 'ArtistLoading';
}

class ArtistLoaded extends ArtistState {
  final List<Artist> artists;

  ArtistLoaded({this.artists}) : super([artists]);

  @override
  String toString() => 'ArtistLoaded';
}

class ArtistError extends ArtistState {
  @override
  String toString() => 'ArtistError';
}
