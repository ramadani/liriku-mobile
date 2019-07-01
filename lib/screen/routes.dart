import 'package:flutter/material.dart';
import 'package:liriku/screen/main/main_screen.dart';
import 'package:liriku/screen/splash/splash_screen.dart';

Map<String, WidgetBuilder> routes(BuildContext context) {
  return {
    SplashScreen.routeName: (context) => SplashScreen(),
    MainScreen.routeName: (context) => MainScreen(),
  };
}
