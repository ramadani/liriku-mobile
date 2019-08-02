import 'package:flutter/material.dart';
import 'package:liriku/bloc/collection/bloc.dart';

class CollectionList extends StatefulWidget {
  final CollectionBloc bloc;

  const CollectionList({Key key, this.bloc}) : super(key: key);

  @override
  _CollectionListState createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  CollectionBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    bloc.dispatch(FetchCollection());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
