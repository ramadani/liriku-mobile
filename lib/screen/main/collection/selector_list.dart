import 'package:flutter/material.dart';

class SelectorItem {
  final String label;
  final bool selected;

  SelectorItem(this.label, this.selected);
}

class SelectorList extends StatefulWidget {
  @override
  _SelectorListState createState() => _SelectorListState();
}

class _SelectorListState extends State<SelectorList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 26,
      itemBuilder: (context, index) {
        final padding =
            EdgeInsets.symmetric(vertical: 4, horizontal: 8).copyWith(
          top: index == 0 ? 8 : 4,
          bottom: index == (26 - 1) ? 8 : 4,
        );

        return Padding(
          padding: padding,
          child: _SelectorItemView(
            item: SelectorItem('A', index == 3),
          ),
        );
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
    final fontColor = item.selected ? Colors.white : Colors.grey[400];

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        color: containerColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            item.label,
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
