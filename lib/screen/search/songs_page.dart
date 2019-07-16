import 'package:flutter/material.dart';

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage>
    with AutomaticKeepAliveClientMixin<SongPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text('Songs'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
