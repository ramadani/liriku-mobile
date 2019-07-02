import 'package:flutter/material.dart';

class ArtistCover extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const ArtistCover({
    Key key,
    this.url,
    this.width = 150,
    this.height = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }
}
