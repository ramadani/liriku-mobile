import 'package:flutter/material.dart';
import 'package:liriku/localizations.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appInfo = '';

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String version = packageInfo.version;

      setState(() {
        _appInfo = '$appName v$version';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/ic_appbar.png',
                width: 64,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                AppLocalizations.of(context).appDescription,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(_appInfo),
            ),
          ],
        ),
      ),
    );
  }
}
