import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/home/artist_event.dart';
import 'package:liriku/bloc/home/artist_state.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final ArtistRepository _artistRepository;

  ArtistBloc(this._artistRepository);

  @override
  ArtistState get initialState => ArtistLoading();

  @override
  Stream<ArtistState> mapEventToState(ArtistEvent event) async* {
    try {
      if (event is FetchTopArtist) {
        final artists = await _artistRepository.getTopArtist();
        if (artists.length > 0) {
          yield ArtistLoaded(artists: artists);
        } else {
          await _artistRepository.syncTopArtist();

          final artists = await _artistRepository.getTopArtist();
          yield ArtistLoaded(artists: artists);
        }
      }
    } catch (e) {
      yield ArtistError();
    }
  }
}
