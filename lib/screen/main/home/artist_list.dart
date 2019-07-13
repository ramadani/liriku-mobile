import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/home/bloc.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/screen/playlist/playlist_screen.dart';
import 'package:liriku/widget/artist_cover.dart';

class ArtistList extends StatefulWidget {
  final ArtistBloc _bloc;

  const ArtistList({Key key, ArtistBloc bloc})
      : _bloc = bloc,
        super(key: key);

  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  ArtistBloc get _bloc => widget._bloc;

  @override
  void initState() {
    super.initState();
    _bloc.dispatch(FetchTopArtist());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, ArtistState state) {
        if (state is ArtistLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ArtistLoaded) {
          final artists = state.artists;

          return ListView.builder(
            itemCount: artists.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return Padding(
                padding:
                EdgeInsets.only(left: index > 0 ? 0 : 16.0, right: 16.0),
                child: GestureDetector(
                  child: _ArtistItem(artist: artist, height: 180),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PlaylistScreen.routeName,
                      arguments:
                      PlaylistScreenArgs(id: artist.id, name: artist.name),
                    );
                  },
                ),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}

class _ArtistItem extends StatelessWidget {
  final Artist _artist;
  final double width;
  final double height;

  const _ArtistItem({
    Key key,
    Artist artist,
    this.width = 150,
    this.height = 180,
  })
      : _artist = artist,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ArtistCover(url: _artist.coverUrl),
          Container(
            width: width,
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              _artist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
