import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/collection/bloc.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/screen/playlist/playlist_screen.dart';
import 'package:liriku/screen/search/empty_result.dart';
import 'package:liriku/screen/search/loading.dart';
import 'package:liriku/widget/artist_tile.dart';

class CollectionList extends StatefulWidget {
  final CollectionBloc bloc;

  const CollectionList({Key key, this.bloc}) : super(key: key);

  @override
  _CollectionListState createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  CollectionBloc get bloc => widget.bloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, CollectionState state) {
        if (state is CollectionLoaded) {
          setState(() {
            _isFetchingMore = state.fetchingMore || !(state.hasMorePages);
          });
        }
      },
      child: BlocBuilder<CollectionEvent, CollectionState>(
        bloc: bloc,
        builder: (BuildContext context, CollectionState state) {
          if (state is CollectionLoaded) {
            final artists = state.artists;

            return ListView.builder(
              itemCount: artists.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                final artistItem = ArtistTile(
                  artist: artists[index],
                  onTap: (BuildContext context, Artist artist) {
                    Navigator.pushNamed(context, PlaylistScreen.routeName,
                        arguments: PlaylistScreenArgs(
                          id: artist.id,
                          name: artist.name,
                        ));
                  },
                );

                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: artistItem,
                  );
                }

                if (index == artists.length - 1 && state.fetchingMore) {
                  return Column(
                    children: <Widget>[
                      artistItem,
                      LoadingSmall(),
                    ],
                  );
                }

                return artistItem;
              },
            );
          } else if (state is CollectionLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CollectionEmpty) {
            return EmptyResult();
          }

          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (!_isFetchingMore) {
        setState(() => _isFetchingMore = true);
        bloc.dispatch(FetchMoreCollection());
      }
    }
  }
}
