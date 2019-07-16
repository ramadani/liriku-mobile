import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
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
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, LyricListState state) {
        if (state is LyricListLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LyricListLoaded) {
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
