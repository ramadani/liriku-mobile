import 'package:equatable/equatable.dart';

abstract class ArtistEvent extends Equatable {
  ArtistEvent([List props = const []]) : super(props);
}

class FetchTopArtist extends ArtistEvent {
  @override
  String toString() => 'FetchTopArtist';
}
