import 'package:flutter/material.dart';
import 'package:liriku/resource/colors.dart';
import 'package:liriku/widget/appbar.dart';

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
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
