import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/bookmark/bookmark_event.dart';
import 'package:liriku/bloc/recentlyread/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/widget/lyric_tile.dart';

class RecentlyReadScreen extends StatelessWidget {
  static const routeName = '/recentlyRead';

  @override
  Widget build(BuildContext context) {
    final bloc = InjectorWidget.of(context).recentlyReadBloc();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recentlyRead),
      ),
      body: _RecentlyReadListView(
        bloc: bloc,
      ),
    );
  }
}

class _RecentlyReadListView extends StatefulWidget {
  final RecentlyReadBloc bloc;

  const _RecentlyReadListView({Key key, this.bloc}) : super(key: key);

  @override
  _RecentlyReadListViewState createState() => _RecentlyReadListViewState();
}

class _RecentlyReadListViewState extends State<_RecentlyReadListView> {
  RecentlyReadBloc get _bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    _bloc.dispatch(FetchRecentlyRead());
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkBloc = InjectorWidget.of(context).bookmarkBloc();

    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, RecentlyReadState state) {
        if (state is RecentlyReadLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is RecentlyReadLoaded) {
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
          );
        }

        return Container();
      },
    );
  }
}
