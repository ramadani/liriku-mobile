import 'package:flutter/material.dart';
import 'package:liriku/resource/colors.dart' as color;

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: color.primary,
    accentColor: color.primaryDark,
    fontFamily: 'Montserrat',
    primaryTextTheme: TextTheme(
      title: TextStyle(
        color: Colors.black87,
      ),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}
