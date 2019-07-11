import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/auth/bloc.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/resource/colors.dart' as color;
import 'package:liriku/screen/main/main_screen.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final authBloc = InjectorWidget.of(context).authBloc();

    return Scaffold(
      body: Container(
        color: color.primaryDark,
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset('assets/images/bg_splash.png'),
            ),
            Positioned(
              bottom: 200,
              left: 120,
              right: 120,
              child: _LoadingIndicator(bloc: authBloc),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatefulWidget {
  final AuthBloc bloc;

  const _LoadingIndicator({Key key, this.bloc}) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  AuthBloc get _bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    _bloc.dispatch(Check());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext context, AuthState state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, MainScreen.routeName);
        }
      },
      child: BlocBuilder<AuthEvent, AuthState>(
        bloc: _bloc,
        builder: (BuildContext context, AuthState state) {
          if (state is Authenticated) {
            return Container();
          }

          return LinearProgressIndicator(
            backgroundColor: Colors.white30,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          );
        },
      ),
    );
  }
}
