import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/playlist/playlist_event.dart';
import 'package:liriku/bloc/playlist/playlist_state.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  StreamSubscription _bookmarkSubscription;
  final ArtistRepository _artistRepository;
  final BookmarkBloc _bookmarkBloc;

  int _adPerPage = 15;

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
    } on Exception catch (e, s) {
      if (currentState is PlaylistLoading) {
        await FlutterCrashlytics().logException(e, s);
        yield PlaylistError();
      }
    }
  }

  Stream<PlaylistState> _mapGetPlaylistToState(GetPlaylist event) async* {
    final artistLyrics =
        await _artistRepository.getArtistDetail(event.artistId);

    final len = artistLyrics.lyrics.length;
    final adRepeatedly = len > _adPerPage;
    final adIndex =
        _getAdIndex(len > _adPerPage ? _adPerPage : len, len > _adPerPage);

    yield PlaylistLoaded(
      artistLyrics: artistLyrics,
      adRepeatedly: adRepeatedly,
      adIndex: adIndex,
    );

    final expiresAt = artistLyrics.updatedAt.add(Duration(days: 7));
    if (expiresAt.isBefore(DateTime.now()) || artistLyrics.lyrics.length <= 1) {
      await _artistRepository.syncArtist(event.artistId);
      await _artistRepository.syncLyrics(event.artistId);

      final newArtistLyrics =
          await _artistRepository.getArtistDetail(event.artistId);

      final newLen = newArtistLyrics.lyrics.length;
      final newAdRepeatedly = newLen > 15;
      final newAdIndex = _getAdIndex(
          newLen > _adPerPage ? _adPerPage : newLen, newLen > _adPerPage);

      yield PlaylistLoaded(
        artistLyrics: newArtistLyrics,
        adRepeatedly: newAdRepeatedly,
        adIndex: newAdIndex,
      );
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
      yield PlaylistLoaded(
        artistLyrics: artistLyrics,
        adRepeatedly: state.adRepeatedly,
        adIndex: state.adIndex,
      );
    }
  }

  @override
  void dispose() {
    _bookmarkSubscription.cancel();
    super.dispose();
  }

  int _getAdIndex(int size, bool gtSize) {
    final start = size - 3;
    if (start > 0 && gtSize) {
      final random = Random();
      final num = start + random.nextInt(size - start);
      return num - 1;
    }

    return size - 1;
  }
}
