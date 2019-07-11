import 'package:flutter/material.dart';
import 'package:liriku/bloc/auth/auth_bloc.dart';
import 'package:liriku/config/config.dart';
import 'package:liriku/config/json_config.dart';
import 'package:liriku/data/provider/api/auth_provider_api.dart';
import 'package:liriku/data/provider/api/http_client.dart';
import 'package:liriku/data/provider/auth_data_provider.dart';
import 'package:liriku/data/provider/auth_provider.dart';
import 'package:liriku/data/provider/prefs/auth_data_provider_prefs.dart';
import 'package:liriku/data/repository/auth_repository.dart';
import 'package:liriku/data/repository/concrete/auth_repository_concrete.dart';
import 'package:meta/meta.dart';

class InjectorWidget extends InheritedWidget {
  String _envFilename;
  Config _config;
  AuthProvider _authProvider;
  AuthDataProvider _authDataProvider;
  AuthRepository _authRepository;

  AuthBloc _authBloc;

  InjectorWidget({
    Key key,
    @required Widget child,
    @required String envFilename,
  })
      : assert(child != null),
        _envFilename = envFilename,
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
    as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  Future<void> init() async {
    _config = JsonConfig();
    await _config.loadFromAssets(_envFilename);

    final config = _config.data();
    final httpClient = HttpClient(config.baseApiUrl, config.apiKey);

    _authProvider = AuthProviderApi(httpClient);
    _authDataProvider = AuthDataProviderPrefs();
    _authRepository = AuthRepositoryConcrete(_authProvider, _authDataProvider);
  }

  AuthBloc authBloc({bool forceCreate = false}) {
    if (_authBloc == null || forceCreate) {
      _authBloc = AuthBloc(_authRepository);
    }

    return _authBloc;
  }
}
