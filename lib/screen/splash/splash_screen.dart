import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liriku/resource/colors.dart' as color;
import 'package:liriku/screen/main/main_screen.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color.primaryDark,
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset('assets/images/bg_splash.png'),
            ),
            Positioned(
              bottom: 160,
              left: 100,
              right: 100,
              child: _LoadingIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  int _start = 2;

  void _startTimer() {
    final oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start < 1) {
          timer.cancel();
          Navigator.pushReplacementNamed(context, MainScreen.routeName);
        } else {
          _start = _start - 1;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white30,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}
