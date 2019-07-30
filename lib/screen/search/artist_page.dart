import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/search/artist_list_bloc.dart';
import 'package:liriku/bloc/search/artist_list_event.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/screen/playlist/playlist_screen.dart';
import 'package:liriku/widget/artist_tile.dart';
import 'package:meta/meta.dart';

import 'empty_result.dart';

class ArtistPage extends StatefulWidget {
  final ArtistListBloc bloc;

  const ArtistPage({Key key, @required this.bloc}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>
    with AutomaticKeepAliveClientMixin<ArtistPage> {
  ArtistListBloc get bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ArtistListEvent, ArtistListState>(
      bloc: bloc,
      builder: (BuildContext context, ArtistListState state) {
        if (state is ArtistListLoaded) {
          final artists = state.artists;

          return ListView.builder(
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final onTap = (BuildContext context, Artist artist) {
                Navigator.pushNamed(context, PlaylistScreen.routeName,
                    arguments: PlaylistScreenArgs(
                      id: artist.id,
                      name: artist.name,
                    ));
              };

              if (index == 0) {
                return Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: ArtistTile(
                    artist: artists[index],
                    onTap: onTap,
                  ),
                );
              }

              return ArtistTile(
                artist: artists[index],
                onTap: onTap,
              );
            },
          );
        } else if (state is ArtistListLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ArtistListEmpty) {
          return EmptyResult();
        }

        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
