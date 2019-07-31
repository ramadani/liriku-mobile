import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/bookmark/bookmark_event.dart';
import 'package:liriku/bloc/bookmarks/bloc.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/screen/search/loading.dart';
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
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  bool _isFetchingMore = false;

  BookmarksBloc get _bloc => widget.bookmarksBloc;

  @override
  void initState() {
    super.initState();

    _bloc.dispatch(FetchBookmarks());
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkBloc = InjectorWidget.of(context).bookmarkBloc();

    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext context, BookmarksState state) {
        if (state is BookmarksLoaded) {
          setState(() {
            _isFetchingMore = state.fetchingMore || !(state.hasMorePages);
          });
        }
      },
      child: BlocBuilder<BookmarksEvent, BookmarksState>(
        bloc: _bloc,
        builder: (BuildContext context, BookmarksState state) {
          if (state is BookmarksLoaded) {
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

                if (index == lyrics.length - 1 && state.fetchingMore) {
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
          } else if (state is BookmarksEmpty) {
            return _BookmarksEmpty();
          }

          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispatch(ResetBookmarks());
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (!_isFetchingMore) {
        setState(() => _isFetchingMore = true);
        _bloc.dispatch(FetchMoreBookmarks());
      }
    }
  }
}

class _BookmarksEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: Colors.grey[400],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                AppLocalizations
                    .of(context)
                    .bookmarkEmpty,
                style: TextStyle(color: Colors.black45),
              ),
            )
          ],
        ),
      ),
    );
  }
}
