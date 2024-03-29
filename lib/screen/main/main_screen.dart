import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/main/collection/collection_screen.dart';
import 'package:liriku/screen/main/home/home_screen.dart';
import 'package:liriku/screen/main/more/more_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    CollectionScreen(),
    MoreScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(AppLocalizations.of(context).home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text(AppLocalizations.of(context).collection),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            title: Text(AppLocalizations.of(context).more),
          ),
        ],
      ),
    );
  }
}
