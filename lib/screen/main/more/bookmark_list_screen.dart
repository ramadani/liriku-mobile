import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/bookmarks/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/widget/lyric_tile.dart';

class BookmarkListScreen extends StatelessWidget {
  static const routeName = '/bookmarks';

  @override
  Widget build(BuildContext context) {
    final bookmarksBloc = InjectorWidget.of(context).bookmarksBloc();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations
            .of(context)
            .bookmark),
      ),
      body: _BookmarkListView(
        bookmarksBloc: bookmarksBloc,
      ),
    );
  }
}

class _BookmarkListView extends StatefulWidget {
  final BookmarksBloc bookmarksBloc;

  const _BookmarkListView({Key key, this.bookmarksBloc}) : super(key: key);

  @override
  _BookmarkListViewState createState() => _BookmarkListViewState();
}

class _BookmarkListViewState extends State<_BookmarkListView> {
  BookmarksBloc get _bloc => widget.bookmarksBloc;

  @override
  void initState() {
    super.initState();
    _bloc.dispatch(FetchBookmarks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksEvent, BookmarksState>(
      bloc: _bloc,
      builder: (BuildContext context, BookmarksState state) {
        if (state is BookmarksLoaded) {
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
  void dispose() {
    _bloc.dispatch(ResetBookmarks());
    super.dispose();
  }
}
