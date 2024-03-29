import 'package:flutter/material.dart';
import 'package:liriku/localizations.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double padding;
  final List<Widget> actions;

  MainAppBar({Key key, this.padding = 0.0, this.actions})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _MainAppBarState();

  @override
  final Size preferredSize;
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/images/ic_appbar.png', height: 22),
          ),
          Text(
            AppLocalizations
                .of(context)
                .title,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: widget.actions,
      elevation: 0,
    );
  }
}
