import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/home/bloc.dart';
import 'package:liriku/widget/lyric_item.dart';

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
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, LyricState state) {
        if (state is LyricLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LyricLoaded) {
          final lyrics = state.lyrics;

          return Column(
            children: List.generate(lyrics.length, (index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0).copyWith(left: 16.0),
                  child: LyricItem(lyric: lyrics[index]),
                ),
              );
            }),
          );
        }

        return Container();
      },
    );
  }
}
