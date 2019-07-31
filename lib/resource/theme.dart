import 'package:flutter/material.dart';
import 'package:liriku/resource/colors.dart' as color;

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: color.primaryDark,
    accentColor: color.primary,
    fontFamily: 'Montserrat',
    primaryTextTheme: TextTheme(
      title: TextStyle(color: Colors.black87),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
      elevation: 2,
      textTheme: Theme
          .of(context)
          .textTheme
          .copyWith(
        title: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
        ),
      ),
      iconTheme: IconThemeData(color: color.primary),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}
