import 'package:flutter/material.dart';
import 'package:liriku/data/model/lyric.dart';

import 'lyric_item.dart';

class LyricTile extends StatelessWidget {
  final Lyric lyric;
  final ItemTapCallback onTap;
  final ItemTapCallback onBookmarkTap;

  const LyricTile({Key key, this.lyric, this.onTap, this.onBookmarkTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap(context, lyric);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0).copyWith(left: 16.0),
        child: LyricItem(
          lyric: lyric,
          onBookmarkTap: onBookmarkTap,
        ),
      ),
    );
  }
}
