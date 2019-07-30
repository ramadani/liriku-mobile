import 'package:flutter/material.dart';
import 'package:liriku/data/model/artist.dart';

import 'artist_cover.dart';

class ArtistTile extends StatelessWidget {
  final Artist artist;

  const ArtistTile({Key key, this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ArtistCover(
            url: artist.coverUrl,
            width: 60,
            height: 60,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                artist.name,
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
