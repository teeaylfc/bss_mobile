import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:dio/dio.dart';

class LogsInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) {
    if (Config.DEBUG) {
      print("Request URL: ${options.path}");
      print('Request header: ' + options.headers.toString());
      if (options.data != null) {
        print('Request parameter: ' + options.data.toString());
      }
    }
    return options;
  }

  @override
  onResponse(Response response) {
    if (Config.DEBUG) {
      if (response != null) {
        print('Response: ' + response.toString());
      }
    }
    return response; 
  }

  @override
  onError(DioError err) {
    if (Config.DEBUG) {
      print('Request exception: ' + err.toString());
      print('Request exception information: ' + err.response?.toString() ?? "");
    }
    return err;
  }
}
