import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/playlist/bloc.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/widget/artist_cover.dart';
import 'package:liriku/widget/lyric_tile.dart';

class PlaylistScreenArgs {
  final String id;
  final String name;

  PlaylistScreenArgs({this.id, this.name});
}

class PlaylistScreen extends StatelessWidget {
  static const routeName = '/playlist';

  @override
  Widget build(BuildContext context) {
    final bloc = InjectorWidget.of(context).playlistBloc();
    final PlaylistScreenArgs args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).playlist),
      ),
      body: SingleChildScrollView(
        child: _PlaylistContent(id: args.id, bloc: bloc),
      ),
    );
  }
}

class _PlaylistContent extends StatefulWidget {
  final String id;
  final PlaylistBloc _bloc;

  const _PlaylistContent({Key key, this.id, PlaylistBloc bloc})
      : _bloc = bloc,
        super(key: key);

  @override
  _PlaylistContentState createState() => _PlaylistContentState();
}

class _PlaylistContentState extends State<_PlaylistContent> {
  PlaylistBloc get _bloc => widget._bloc;

  @override
  void initState() {
    super.initState();
    _bloc.dispatch(GetPlaylist(artistId: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkBloc = InjectorWidget.of(context).bookmarkBloc();

    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, PlaylistState state) {
        if (state is PlaylistLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PlaylistLoaded) {
          final lyrics = state.lyrics;
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                child: _PlaylistArtist(artist: state.artist),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 10.0),
                child: Divider(
                  color: Colors.grey[400],
                  height: 10,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: lyrics.length,
                itemBuilder: (context, index) {
                  return LyricTile(
                    lyric: lyrics[index],
                    onTap: (BuildContext context, Lyric lyric) {
                      Navigator.pushNamed(context, LyricScreen.routeName,
                          arguments: LyricScreenArgs(id: lyric.id));
                    },
                    onBookmarkTap: (BuildContext context, Lyric lyric) {
                      bookmarkBloc.dispatch(BookmarkPressed(
                        id: lyric.id,
                        bookmarked: !lyric.bookmarked,
                      ));
                    },
                  );
                },
                physics: NeverScrollableScrollPhysics(),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}

class _PlaylistArtist extends StatelessWidget {
  final Artist artist;

  const _PlaylistArtist({Key key, this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ArtistCover(url: artist.coverUrl),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  artist.name,
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 22,
                    fontWeight: FontWeight.bold,
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    AppLocalizations.of(context).playlist,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
