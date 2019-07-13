import 'package:flutter/material.dart';
import 'package:liriku/data/model/lyric.dart';

import 'lyric_item.dart';

class LyricTile extends StatelessWidget {
  final Lyric lyric;

  const LyricTile({Key key, this.lyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0).copyWith(left: 16.0),
        child: LyricItem(lyric: lyric),
      ),
    );
  }
}
