import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/resource/theme.dart';
import 'package:liriku/screen/routes.dart';
import 'package:liriku/screen/splash/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('id'),
      ],
      onGenerateTitle: (context) =>
      AppLocalizations
          .of(context)
          .title,
      theme: appTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
