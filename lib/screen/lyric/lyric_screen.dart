import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:liriku/bloc/bookmark/bloc.dart';
import 'package:liriku/bloc/lyric/bloc.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/screen/playlist/playlist_screen.dart';
import 'package:liriku/widget/bookmark_action.dart';

class LyricScreenArgs {
  final String id;

  LyricScreenArgs({this.id});
}

class LyricScreen extends StatelessWidget {
  static const routeName = '/lyric';

  @override
  Widget build(BuildContext context) {
    final LyricScreenArgs args = ModalRoute.of(context).settings.arguments;
    final lyricBloc = InjectorWidget.of(context).lyricBloc();
    final bookmarkBloc = InjectorWidget.of(context).bookmarkBloc();

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          BlocBuilder(
            bloc: bookmarkBloc,
            builder: (BuildContext context, BookmarkState state) {
              bool bookmarked = false;
              if (state is BookmarkInitialized) {
                bookmarked = state.bookmarked;
              } else if (state is BookmarkChanged) {
                bookmarked = state.bookmarked;
              }

              return BookmarkAction(
                bookmarked: bookmarked,
                onPressed: () {
                  bookmarkBloc.dispatch(BookmarkPressed(
                    id: args.id,
                    bookmarked: !bookmarked,
                  ));
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _LyricContent(id: args.id, bloc: lyricBloc),
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
          final artist = lyric.artist;
          final content = html2md.convert(lyric.content);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PlaylistScreen.routeName,
                          arguments: PlaylistScreenArgs(
                            id: artist.id,
                            name: artist.name,
                          ));
                    },
                    child: Text(
                      lyric.artist.name,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: MarkdownBody(
                    data: content,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                        p: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(height: 1.2)),
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
