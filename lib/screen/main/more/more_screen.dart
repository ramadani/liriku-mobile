import 'package:flutter/material.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/main/more/bookmark_list_screen.dart';
import 'package:liriku/screen/main/more/recently_read_screen.dart';

enum MenuType { Bookmark, RecentlyRead, About }

class Menu {
  final MenuType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final String routeName;

  Menu(this.type, this.title, this.subtitle, this.icon, this.routeName);
}

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Menu> menus = List();

    menus.add(Menu(
      MenuType.Bookmark,
      AppLocalizations.of(context).bookmark,
      AppLocalizations.of(context).bookmarkSubtitle,
      Icons.collections_bookmark,
      BookmarkListScreen.routeName,
    ));
    menus.add(Menu(
      MenuType.RecentlyRead,
      AppLocalizations.of(context).recentlyRead,
      AppLocalizations.of(context).recentlyReadSubtitle,
      Icons.history,
      RecentlyReadScreen.routeName,
    ));
    menus.add(Menu(
      MenuType.About,
      AppLocalizations.of(context).about,
      AppLocalizations.of(context).aboutSubtitle,
      Icons.info,
      BookmarkListScreen.routeName,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).exploreMore),
      ),
      body: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          return InkWell(
            onTap: () => Navigator.pushNamed(context, menu.routeName),
            child: Column(
              children: <Widget>[
                _MenuItem(menu: menu),
                Divider(height: 0),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Menu menu;

  const _MenuItem({Key key, this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Icon(menu.icon, color: Theme.of(context).primaryColor),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  menu.title,
                  style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Theme.of(context).primaryColor),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    menu.subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
