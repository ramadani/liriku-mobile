import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/screen/search/empty_result.dart';
import 'package:liriku/screen/search/loading.dart';
import 'package:liriku/widget/lyric_tile.dart';
import 'package:meta/meta.dart';

class SongPage extends StatefulWidget {
  final LyricListBloc bloc;

  const SongPage({Key key, @required this.bloc}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage>
    with AutomaticKeepAliveClientMixin<SongPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  bool _isFetchingMore = false;

  LyricListBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookmarkBloc = InjectorWidget.of(context).bookmarkBloc();

    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, LyricListState state) {
        if (state is LyricListLoaded) {
          setState(
                () =>
            _isFetchingMore = state.fetchingMore || !(state.hasMorePages),
          );
        }
      },
      child: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, LyricListState state) {
          if (state is LyricListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LyricListEmpty) {
            return EmptyResult();
          } else if (state is LyricListLoaded) {
            final lyrics = state.lyrics;

            return ListView.builder(
              itemCount: lyrics.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                final lyricItem = LyricTile(
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

                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: lyricItem,
                  );
                } else if (index == lyrics.length - 1 && state.fetchingMore) {
                  return Column(
                    children: <Widget>[
                      lyricItem,
                      LoadingSmall(),
                    ],
                  );
                }

                return lyricItem;
              },
            );
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
        bloc.dispatch(FetchMoreLyricList());
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
