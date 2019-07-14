import 'package:flutter/material.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/widget/bookmark_action.dart';

typedef ItemTapCallback = void Function(BuildContext context, Lyric lyric);

class LyricItem extends StatelessWidget {
  final Lyric _lyric;
  final ItemTapCallback onBookmarkTap;

  const LyricItem({Key key, Lyric lyric, this.onBookmarkTap})
      : _lyric = lyric,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> labels = List();
    final title = Text(
      _lyric.title,
      style: Theme.of(context)
          .textTheme
          .title
          .copyWith(fontWeight: FontWeight.w600, fontSize: 16.0),
    );
    labels.add(title);

    if (_lyric is LyricArtist) {
      final artistName = Padding(
        padding: EdgeInsets.only(top: 2.0),
        child: Text(
          (_lyric as LyricArtist).artist.name,
          style: TextStyle(color: Colors.black54),
        ),
      );
      labels.add(artistName);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: labels,
          ),
        ),
        BookmarkAction(
          bookmarked: _lyric.bookmarked,
          onPressed: () {
            if (onBookmarkTap != null) {
              onBookmarkTap(context, _lyric);
            }
          },
        ),
      ],
    );
  }
}
