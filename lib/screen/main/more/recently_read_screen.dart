import 'package:flutter/material.dart';
import 'package:liriku/localizations.dart';

class RecentlyReadScreen extends StatelessWidget {
  static const routeName = '/recentlyRead';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recentlyRead),
      ),
      body: _RecentlyReadListView(),
    );
  }
}

class _RecentlyReadListView extends StatefulWidget {
  @override
  _RecentlyReadListViewState createState() => _RecentlyReadListViewState();
}

class _RecentlyReadListViewState extends State<_RecentlyReadListView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
