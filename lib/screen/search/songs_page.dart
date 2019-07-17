import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/screen/search/empty_result.dart';
import 'package:liriku/widget/lyric_tile.dart';

class SongPage extends StatefulWidget {
  final LyricListBloc bloc;

  const SongPage({Key key, this.bloc}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage>
    with AutomaticKeepAliveClientMixin<SongPage> {
  LyricListBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    bloc.dispatch(FetchLyricList());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, LyricListState state) {
        if (state is LyricListLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LyricListEmpty) {
          print('state empty');
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

              if (index == 0) {
                return Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: LyricTile(lyric: lyrics[index], onTap: onTap),
                );
              }

              return LyricTile(lyric: lyrics[index], onTap: onTap);
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
