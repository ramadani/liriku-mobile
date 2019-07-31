import 'package:flutter/material.dart';
import 'package:liriku/screen/lyric/lyric_screen.dart';
import 'package:liriku/screen/main/main_screen.dart';
import 'package:liriku/screen/main/more/bookmark_list_screen.dart';
import 'package:liriku/screen/playlist/playlist_screen.dart';
import 'package:liriku/screen/search/search_screen.dart';
import 'package:liriku/screen/splash/splash_screen.dart';

Map<String, WidgetBuilder> routes(BuildContext context) {
  return {
    SplashScreen.routeName: (context) => SplashScreen(),
    MainScreen.routeName: (context) => MainScreen(),
    PlaylistScreen.routeName: (context) => PlaylistScreen(),
    LyricScreen.routeName: (context) => LyricScreen(),
    SearchScreen.routeName: (context) => SearchScreen(),
    BookmarkListScreen.routeName: (context) => BookmarkListScreen(),
  };
}
