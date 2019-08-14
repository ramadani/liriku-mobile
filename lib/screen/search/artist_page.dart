import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/search/artist_list_bloc.dart';
import 'package:liriku/bloc/search/artist_list_event.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/screen/playlist/playlist_screen.dart';
import 'package:liriku/widget/ad_banner.dart';
import 'package:liriku/widget/artist_tile.dart';
import 'package:meta/meta.dart';

import 'empty_result.dart';
import 'loading.dart';

class ArtistPage extends StatefulWidget {
  final ArtistListBloc bloc;

  const ArtistPage({Key key, @required this.bloc}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>
    with AutomaticKeepAliveClientMixin<ArtistPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  bool _hasInit = false;
  bool _isFetchingMore = false;

  @override
  bool get wantKeepAlive => true;

  ArtistListBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, ArtistListState state) {
        if (state is ArtistListLoaded) {
          setState(() {
            _hasInit = true;
            _isFetchingMore = state.fetchingMore || !(state.hasMorePages);
          });
        }
      },
      child: BlocBuilder<ArtistListEvent, ArtistListState>(
        bloc: bloc,
        builder: (BuildContext context, ArtistListState state) {
          if (state is ArtistListLoaded) {
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
                  return Container(
                    margin: EdgeInsets.only(top: 16.0),
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

                // Ad
                if (state.adRepeatedly) {
                  if (index > 0 && index % state.adIndex == 0) {
                    return Column(
                      children: [artistItem, AdBanner(isPadding: false)],
                    );
                  }
                } else {
                  if (index == state.adIndex) {
                    return Column(
                      children: [artistItem, AdBanner(isPadding: false)],
                    );
                  }
                }

                return artistItem;
              },
            );
          } else if (state is ArtistListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ArtistListEmpty) {
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
      if (!_isFetchingMore && _hasInit) {
        setState(() => _isFetchingMore = true);
        bloc.dispatch(FetchMoreArtistList());
      }
    }
  }
}
