import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/collection/bloc.dart';
import 'package:liriku/bloc/collection/selector_bloc.dart';

class SelectorList extends StatefulWidget {
  final SelectorBLoc bloc;

  const SelectorList({Key key, this.bloc}) : super(key: key);

  @override
  _SelectorListState createState() => _SelectorListState();
}

class _SelectorListState extends State<SelectorList> {
  SelectorBLoc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    bloc.dispatch(FetchSelector());
  }

  @override
  Widget build(BuildContext context) {
    final verticalPad = 6.0;

    return BlocBuilder<SelectorEvent, SelectorState>(
      bloc: bloc,
      builder: (BuildContext context, SelectorState state) {
        if (state is SelectorLoaded) {
          final items = state.items;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final padding =
                  EdgeInsets.symmetric(vertical: verticalPad, horizontal: 8)
                      .copyWith(
                top: index == 0 ? (verticalPad * 2) + 2 : verticalPad,
                bottom: index == (items.length - 1)
                    ? (verticalPad * 2) + 2
                    : verticalPad,
              );

              return Padding(
                padding: index == 0 ? padding.copyWith(top: 24) : padding,
                child: InkWell(
                  onTap: () {
                    bloc.dispatch(SelectSelector(id: item.collection.id));
                  },
                  child: _SelectorItemView(
                    item: item,
                  ),
                ),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}

class _SelectorItemView extends StatelessWidget {
  final SelectorItem item;

  const _SelectorItemView({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerColor =
        item.selected ? Theme.of(context).primaryColor : Colors.grey[100];
    final fontColor = item.selected ? Colors.white : Colors.grey[500];

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        color: containerColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            item.collection.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
