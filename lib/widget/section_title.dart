import 'package:flutter/material.dart';
import 'package:liriku/resource/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const SectionTitle({Key key, this.title, this.subtitle, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  subtitle,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: primaryDark,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Icon(icon, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
