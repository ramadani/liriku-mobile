import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/lyric/bloc.dart';
import 'package:liriku/injector_widget.dart';

class LyricScreenArgs {
  final String id;

  LyricScreenArgs({this.id});
}

class LyricScreen extends StatelessWidget {
  static const routeName = '/lyric';

  @override
  Widget build(BuildContext context) {
    final LyricScreenArgs args = ModalRoute.of(context).settings.arguments;
    final bloc = InjectorWidget.of(context).lyricBloc();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: _LyricContent(id: args.id, bloc: bloc),
      ),
    );
  }
}

class _LyricContent extends StatefulWidget {
  final String id;
  final LyricBloc _bloc;

  const _LyricContent({Key key, this.id, LyricBloc bloc})
      : _bloc = bloc,
        super(key: key);

  @override
  _LyricContentState createState() => _LyricContentState();
}

class _LyricContentState extends State<_LyricContent> {
  LyricBloc get _bloc => widget._bloc;

  @override
  void initState() {
    super.initState();
    _bloc.dispatch(GetLyric(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, LyricState state) {
        if (state is LyricLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LyricLoaded) {
          final lyric = state.lyric;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Text(
                  lyric.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .title
                      .copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    lyric.artist.name,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}