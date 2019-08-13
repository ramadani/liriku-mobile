import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/home/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/widget/lyric_tile.dart';

class LyricList extends StatefulWidget {
  final LyricBloc _bloc;

  const LyricList({Key key, LyricBloc bloc})
      : _bloc = bloc,
        super(key: key);

  @override
  _LyricListState createState() => _LyricListState();
}

class _LyricListState extends State<LyricList> {
  LyricBloc get _bloc => widget._bloc;

  @override
  void initState() {
    super.initState();
    _bloc.dispatch(FetchTopLyric());
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkBloc = InjectorWidget.of(context).bookmarkBloc();

    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, LyricState state) {
        if (state is LyricLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LyricLoaded) {
          final lyrics = state.lyrics;

          return ListView.builder(
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          );
        }

        return Container();
      },
    );
  }
}
