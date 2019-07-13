import 'package:flutter/material.dart';
import 'package:liriku/injector_widget.dart';

class LyricScreenArgs {
  final String id;

  LyricScreenArgs({this.id});
}

class LyricScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LyricScreenArgs args = ModalRoute.of(context).settings.arguments;
    final bloc = InjectorWidget.of(context).lyricBloc();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: _LyricContent(),
      ),
    );
  }
}

class _LyricContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
