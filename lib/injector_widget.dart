import 'package:flutter/material.dart';
import 'package:liriku/bloc/auth/auth_bloc.dart';
import 'package:liriku/data/provider/api/auth_provider_api.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/auth_provider.dart';
import 'package:liriku/data/repository/auth_repository.dart';
import 'package:liriku/data/repository/concrete/auth_repository_concrete.dart';

class InjectorWidget extends InheritedWidget {
  AuthProvider _authProvider;
  AuthRepository _authRepository;

  AuthBloc _authBloc;

  InjectorWidget({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
        as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  Future<void> init() async {
    final httpClient = HttpClient(
      "https://us-central1-liriku-dev.cloudfunctions.net/api",
      "v5FSR3CPJ2VKcZwVJ7Ko9blC02f7v3VahVpcojmQSN5YKWHfjQxeO7Gbrbboqt01RYAICBhKIAQP9Tfu31i2TawnY3Yt7kvCGJeZB7ssBnEQEJX1u9Ebs5hkKKOeBiN2",
    );

    _authProvider = AuthProviderApi(httpClient);
    _authRepository = AuthRepositoryConcrete(_authProvider);
  }

  AuthBloc authBloc({bool forceCreate = false}) {
    if (_authBloc == null || forceCreate) {
      _authBloc = AuthBloc(_authRepository);
    }

    return _authBloc;
  }
}
