import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:liriku/injector_widget.dart';

import 'app.dart';

void main() async {
  final app = InjectorWidget(child: App());
  await app.init();

  BlocSupervisor.delegate = _SimpleBlocDelegate();
  runApp(app);
}

class _SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
