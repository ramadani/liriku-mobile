import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/screen/search/empty_result.dart';
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
  LyricListBloc get bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookmarkBloc = InjectorWidget.of(context).bookmarkBloc();

    return BlocBuilder(
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
            itemBuilder: (context, index) {
              final onTap = (BuildContext context, Lyric lyric) {
                Navigator.pushNamed(context, LyricScreen.routeName,
                    arguments: LyricScreenArgs(id: lyric.id));
              };
              final onBookmarkTap = (BuildContext context, Lyric lyric) {
                bookmarkBloc.dispatch(BookmarkPressed(
                  id: lyric.id,
                  bookmarked: !lyric.bookmarked,
                ));
              };

              if (index == 0) {
                return Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: LyricTile(
                    lyric: lyrics[index],
                    onTap: onTap,
                    onBookmarkTap: onBookmarkTap,
                  ),
                );
              }

              return LyricTile(
                lyric: lyrics[index],
                onTap: onTap,
                onBookmarkTap: onBookmarkTap,
              );
            },
          );
        }

        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
