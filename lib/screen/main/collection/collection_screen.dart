import 'package:flutter/material.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/main/collection/collection_list.dart';
import 'package:liriku/screen/main/collection/selector_list.dart';

class CollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectorBloc = InjectorWidget.of(context).selectorBLoc();
    final collectionBloc = InjectorWidget.of(context).collectionBloc();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).collection),
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: 52,
            child: SelectorList(
              bloc: selectorBloc,
            ),
          ),
          Expanded(
            child: CollectionList(
              bloc: collectionBloc,
            ),
          ),
        ],
      ),
    );
  }
}
