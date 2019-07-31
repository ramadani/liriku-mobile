import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/playlist/playlist_event.dart';
import 'package:liriku/bloc/playlist/playlist_state.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  StreamSubscription _bookmarkSubscription;
  final ArtistRepository _artistRepository;
  final BookmarkBloc _bookmarkBloc;

  PlaylistBloc(this._artistRepository, this._bookmarkBloc) {
    _bookmarkSubscription = _bookmarkBloc.state.listen((BookmarkState state) {
      if (state is BookmarkChanged) {
        dispatch(ChangeBookmarkInPlaylist(
          lyricId: state.id,
          bookmarked: state.bookmarked,
        ));
      }
    });
  }

  @override
  PlaylistState get initialState => PlaylistLoading();

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
    try {
      if (event is GetPlaylist) {
        yield* _mapGetPlaylistToState(event);
      } else if (event is ChangeBookmarkInPlaylist) {
        if (currentState is PlaylistLoaded) {
          yield* _mapChangeBookmarkToState(
              event, currentState as PlaylistLoaded);
        }
      }
    } catch (e) {
      if (currentState is PlaylistLoading) {
        yield PlaylistError();
      }
    }
  }

  Stream<PlaylistState> _mapGetPlaylistToState(GetPlaylist event) async* {
    final artistLyrics =
    await _artistRepository.getArtistDetail(event.artistId);
    yield PlaylistLoaded(artistLyrics: artistLyrics);

    final expiresAt = artistLyrics.updatedAt.add(Duration(days: 7));
    if (expiresAt.isBefore(DateTime.now()) || artistLyrics.lyrics.length <= 1) {
      await _artistRepository.syncArtist(event.artistId);
      await _artistRepository.syncLyrics(event.artistId);

      final newArtistLyrics =
      await _artistRepository.getArtistDetail(event.artistId);

      yield PlaylistLoaded(artistLyrics: newArtistLyrics);
    }
  }

  Stream<PlaylistState> _mapChangeBookmarkToState(
      ChangeBookmarkInPlaylist event, PlaylistLoaded state) async* {
    if (state.lyrics.length > 0) {
      final lyrics = state.lyrics.map((Lyric it) {
        return it.id == event.lyricId
            ? it.copyWith(bookmarked: event.bookmarked)
            : it.copyWith(bookmarked: it.bookmarked);
      }).toList();

      final artistLyrics = state.artistLyrics.copyWith(lyrics: lyrics);
      yield PlaylistLoaded(artistLyrics: artistLyrics);
    }
  }

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }
}
