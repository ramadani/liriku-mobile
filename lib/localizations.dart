import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'resource/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  String get title {
    return Intl.message('Liriku', name: 'title', desc: 'The application title');
  }

  String get appDescription {
    return Intl.message(
      "Get your favourite music's lyrics",
      name: 'appDescription',
    );
  }

  String get home {
    return Intl.message('Home', name: 'home');
  }

  String get collection {
    return Intl.message('Collection', name: 'collection');
  }

  String get more {
    return Intl.message('More', name: 'more');
  }

  String get artists {
    return Intl.message('Artists', name: 'artists');
  }

  String get artistsDescSection {
    return Intl.message('Top Ten New Artist\'s Lyrics',
        name: 'artistsDescSection');
  }

  String get songs {
    return Intl.message('Songs', name: 'songs');
  }

  String get songsDescSection {
    return Intl.message('Top Ten New Lyrics', name: 'songsDescSection');
  }

  String get playlist {
    return Intl.message('Playlist', name: 'playlist');
  }

  String get search {
    return Intl.message('Search Song or Artist', name: 'search');
  }

  String get searchArtist {
    return Intl.message('Search Artist', name: 'searchArtist');
  }

  String get searchEmptyResult {
    return Intl.message("Can't find any data that you're looking for",
        name: 'searchEmptyResult');
  }

  String get exploreMore {
    return Intl.message('Explore More', name: 'exploreMore');
  }

  String get bookmark {
    return Intl.message('Bookmark', name: 'bookmark');
  }

  String get bookmarkSubtitle {
    return Intl.message("Your bank lyrics", name: 'bookmarkSubtitle');
  }

  String get bookmarkEmpty {
    return Intl.message("Bookmark Empty", name: 'bookmarkEmpty');
  }

  String get recentlyRead {
    return Intl.message('Recently Read', name: 'recentlyRead');
  }

  String get recentlyReadEmpty {
    return Intl.message('No History Read', name: 'recentlyReadEmpty');
  }

  String get recentlyReadSubtitle {
    return Intl.message(
      "The lyrics that you've read",
      name: 'recentlyReadSubtitle',
    );
  }

  String get about {
    return Intl.message('About', name: 'about');
  }

  String get aboutSubtitle {
    return Intl.message("About Liriku Application", name: 'aboutSubtitle');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
