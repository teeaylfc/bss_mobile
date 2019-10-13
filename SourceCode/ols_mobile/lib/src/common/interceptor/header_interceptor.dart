import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:dio/dio.dart';

class HeaderInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) {
    options.connectTimeout = Config.CONNECTION_TIMEOUT;
    return options;
  }
}