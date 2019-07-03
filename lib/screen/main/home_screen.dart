import 'package:flutter/material.dart';
import 'package:liriku/data/model/artist.dart';
import 'package:liriku/data/model/lyric.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/resource/colors.dart';
import 'package:liriku/widget/appbar.dart';
import 'package:liriku/widget/artist_cover.dart';
import 'package:liriku/widget/lyric_item.dart';
import 'package:liriku/widget/section_title.dart';

class HomeScreen extends StatelessWidget {
  final artists = [
    Artist(
        id: 'a',
        name: "Taylor Swift",
        coverUrl:
        "https://static.spin.com/files/2017/06/red-1497635192-640x640.jpg"),
    Artist(
        id: 'b',
        name: "Raisa",
        coverUrl:
        "http://1.bp.blogspot.com/-_fkL8GsP-_w/VoI3b0Zwy7I/AAAAAAAAAiU/ML2iosJIBfs/s1600/raisa-yovie.jpg"),
    Artist(
        id: 'c',
        name: "Ungu",
        coverUrl:
        "http://3.bp.blogspot.com/-GfSn6y-d0Mc/TpcWp0wfx1I/AAAAAAAAANs/X75pnGCD2LI/s1600/lauching+album+ungu+1000+kisah+1+hati.jpg"),
  ];

  final lyrics = [
    LyricArtist(
      id: "a",
      title: "What is Lorem Ipsum?",
      artist: Artist(id: 'a', name: "Lorem Ipsum"),
      bookmarked: false,
    ),
    LyricArtist(
      id: "b",
      title: "Lorem Ipsum is simply",
      artist: Artist(id: 'a', name: "Ipsum Lorem"),
      bookmarked: true,
    ),
    LyricArtist(
      id: "c",
      title: "Where does it come from?",
      artist: Artist(id: 'a', name: "Lorem Ipsum"),
      bookmarked: false,
    ),
    LyricArtist(
      id: "d",
      title: "Where can I get some?",
      artist: Artist(id: 'a', name: "Ipsum Lorem"),
      bookmarked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Artist> artists = List();
    final List<Lyric> lyrics = List();
    artists.addAll(this.artists);
    artists.addAll(this.artists);
    artists.addAll(this.artists);
    lyrics.addAll(this.lyrics);
    lyrics.addAll(this.lyrics);

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
                title: AppLocalizations
                    .of(context)
                    .artists,
                subtitle: AppLocalizations
                    .of(context)
                    .artistsDescSection,
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: artists.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: index > 0 ? 0 : 16.0, right: 16.0),
                    child: _ArtistItem(artist: artists[index], height: 180),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(top: 32.0, bottom: 16.0),
              child: SectionTitle(
                icon: Icons.music_note,
                title: AppLocalizations
                    .of(context)
                    .songs,
                subtitle: AppLocalizations
                    .of(context)
                    .songsDescSection,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.grey[400]),
            ),
            Column(
              children: List.generate(lyrics.length, (index) {
                return InkWell(
                  onTap: () {},
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: LyricItem(lyric: lyrics[index]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtistItem extends StatelessWidget {
  final Artist _artist;
  final double height;

  const _ArtistItem({Key key, Artist artist, this.height})
      : _artist = artist,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ArtistCover(
            url: _artist.coverUrl,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              _artist.name,
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
