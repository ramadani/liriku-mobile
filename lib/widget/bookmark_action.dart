import 'package:flutter/material.dart';
import 'package:liriku/resource/colors.dart';
import 'package:meta/meta.dart';

class BookmarkAction extends StatelessWidget {
  final bool bookmarked;
  final VoidCallback onPressed;

  const BookmarkAction(
      {Key key, this.bookmarked = false, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.bookmark,
        color: bookmarked ? primaryDark : Colors.grey,
      ),
      onPressed: onPressed,
    );
  }
}
