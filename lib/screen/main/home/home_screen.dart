import 'package:flutter/material.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/resource/colors.dart';
import 'package:liriku/screen/main/home/artist_list.dart';
import 'package:liriku/screen/main/home/lyric_list.dart';
import 'package:liriku/screen/search/search_screen.dart';
import 'package:liriku/widget/appbar.dart';
import 'package:liriku/widget/section_title.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final artistBloc = InjectorWidget.of(context).homeArtistBloc();
    final lyricBloc = InjectorWidget.of(context).homeLyricBloc();

    final artistSection = SectionTitle(
      icon: Icons.trending_up,
      title: AppLocalizations
          .of(context)
          .artists,
      subtitle: AppLocalizations
          .of(context)
          .artistsDescSection,
    );
    final lyricSection = SectionTitle(
      icon: Icons.music_note,
      title: AppLocalizations
          .of(context)
          .songs,
      subtitle: AppLocalizations
          .of(context)
          .songsDescSection,
    );

    return Scaffold(
      appBar: MainAppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: primaryDark),
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: artistSection,
            ),
            SizedBox(
              height: 180,
              child: ArtistList(bloc: artistBloc),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(top: 32.0, bottom: 16.0),
              child: lyricSection,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.grey[400]),
            ),
            LyricList(bloc: lyricBloc),
          ],
        ),
      ),
    );
  }
}
