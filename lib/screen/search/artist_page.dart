import 'package:flutter/material.dart';

class ArtistPage extends StatefulWidget {
  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>
    with AutomaticKeepAliveClientMixin<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text('Artists'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
