import 'dart:async';

import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/models/account_info_model.dart';
import 'package:ols_mobile/src/models/bloc_delegate.dart';
import 'package:ols_mobile/src/models/load_state.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/service/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  AuthService authService = AuthService();
  BlocDelegate<User> delegate;

  final _loadingStateController = StreamController<LoadState>();
  final _loginController = StreamController<Map>();

  Stream<LoadState> get loadState => _loadingStateController.stream;

  Function(LoadState) get changeLoadState => (loadState) => _loadingStateController.sink.add(loadState);

  AuthBloc({this.delegate});

  login(username, password) async {
    _startAuthProcess(() {
      return authService.login(username, password);
    });
  }

    loginBiometric(username, password) async {
    _startAuthProcess(() {
      return authService.biometricAuthenticate(username, password);
    });
  }

  loginSocial(provider,name, email ,userId, imageUrl) async {
    _startAuthProcess(() {
      return authService.loginSocial(provider, name, email, userId, imageUrl);
    });
  }

  register(email, fullName, password) async {
    _startAuthProcess(() {
      return authService.register(email, fullName, password);
    });
  }

  _startAuthProcess(Future<dynamic> Function() authResponse) async {
    try {
      _loadingStateController.sink.add(Loading());
      AccountInfo accountInfo = await authResponse();
      _loadingStateController.sink.add(Loaded());
      User user = User(fullName: accountInfo.fullName, imageURL: accountInfo.urlAvatar);
      // user.walletCount = res['data']['offerCount'];
      delegate.success(user);
    } catch (error) {
      changeLoadState(Loaded());
      delegate.error(error);
    }
  }

  @override
  void dispose() {
    _loginController.close();
    _loadingStateController.close();
  }
}
