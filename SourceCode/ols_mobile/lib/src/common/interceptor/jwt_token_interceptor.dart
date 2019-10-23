import 'package:ols_mobile/src/common/shared_preferences_util.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenInterceptor extends InterceptorsWrapper {

    final _storage = new FlutterSecureStorage();

  @override
  onRequest(RequestOptions options) async {
    options.headers['Content-Type'] = "application/json";
    String _token = await getToken();
    if (_token != null) {
      print(_token);
      options.headers['Authorization'] = 'Bearer ' + _token;
    }
    return options;
  }

  getToken() async {
    return await _storage.read(key: Config.TOKEN_KEY);
  }
}
