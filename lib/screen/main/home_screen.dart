import 'package:flutter/material.dart';
import 'package:liriku/resource/colors.dart';
import 'package:liriku/widget/appbar.dart';
import 'package:liriku/widget/artist_cover.dart';
import 'package:liriku/widget/section_title.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: primaryDark),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: SectionTitle(
                icon: Icons.trending_up,
                title: 'Artist',
                subtitle: 'Top Ten New Artist\'s Lyrics',
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index > 0 ? 0 : 16.0,
                      right: 16.0,
                    ),
                    child: _ArtistItem(
                      height: 180,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtistItem extends StatelessWidget {
  final double height;

  const _ArtistItem({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ArtistCover(
            url:
            'https://static.spin.com/files/2017/06/red-1497635192-640x640.jpg',
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Taylor Swift',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme
                  .of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
