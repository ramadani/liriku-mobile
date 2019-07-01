import 'package:flutter/material.dart';
import 'package:liriku/resource/theme.dart';
import 'package:liriku/screen/routes.dart';
import 'package:liriku/screen/splash/splash_screen.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liriku',
      theme: appTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
