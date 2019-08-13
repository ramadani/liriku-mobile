import 'package:flutter/material.dart';
import 'package:liriku/data/model/artist.dart';

import 'artist_cover.dart';

typedef ItemTapCallback = void Function(BuildContext context, Artist artist);

class ArtistTile extends StatelessWidget {
  final Artist artist;
  final ItemTapCallback onTap;

  const ArtistTile({Key key, this.artist, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap(context, artist);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: <Widget>[
            ArtistCover(url: artist.coverUrl, width: 72, height: 72),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  artist.name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .title
                      .copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
