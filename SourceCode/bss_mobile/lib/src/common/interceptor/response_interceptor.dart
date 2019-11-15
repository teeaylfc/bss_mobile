import 'package:bss_mobile/src/common/exception/http_code.dart';
import 'package:bss_mobile/src/common/response_data.dart';
import 'package:dio/dio.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) {
    try {
      return ResponseData(response.data, true, HttpCode.SUCCESS);
    } catch (e) {
      return ResponseData(response.data, false, response.statusCode, headers: response.headers);
    }
  }
}
