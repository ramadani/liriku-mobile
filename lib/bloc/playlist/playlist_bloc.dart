import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/playlist/playlist_event.dart';
import 'package:liriku/bloc/playlist/playlist_state.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final ArtistRepository _artistRepository;

  PlaylistBloc(this._artistRepository);

  @override
  PlaylistState get initialState => PlaylistLoading();

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
    try {
      if (event is GetPlaylist) {
        final artistLyrics =
            await _artistRepository.getArtistDetail(event.artistId);
        yield PlaylistLoaded(artistLyrics: artistLyrics);

        final expiresAt = artistLyrics.updatedAt.add(Duration(days: 7));
        if (expiresAt.isBefore(DateTime.now()) ||
            artistLyrics.lyrics.length <= 1) {
          final newArtistLyrics =
              await _artistRepository.syncAndGetArtistDetail(event.artistId);
          yield PlaylistLoaded(artistLyrics: newArtistLyrics);
        }
      }
    } catch (e) {
      if (currentState is PlaylistLoading) {
        yield PlaylistError();
      }
    }
  }
}
