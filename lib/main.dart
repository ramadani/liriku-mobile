import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:liriku/injector_widget.dart';

import 'app.dart';

void main() async {
  bool isInDebugMode = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await FlutterCrashlytics().initialize();

  runZoned<Future<Null>>(() async {
    final app = InjectorWidget(child: App(), envFilename: 'env.json');
    await app.init();

    BlocSupervisor.delegate = _SimpleBlocDelegate();
    runApp(app);
  }, onError: (error, stackTrace) async {
    await FlutterCrashlytics()
        .reportCrash(error, stackTrace, forceCrash: false);
  });
}

class _SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
