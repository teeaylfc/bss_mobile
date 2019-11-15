import 'dart:collection';

import 'package:connectivity/connectivity.dart';
import 'package:bss_mobile/src/common/interceptor/header_interceptor.dart';
import 'package:bss_mobile/src/common/interceptor/jwt_token_interceptor.dart';
import 'package:bss_mobile/src/common/interceptor/log_interceptor.dart';
import 'package:dio/dio.dart';

class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = Dio();

  HttpManager() {
    _dio.interceptors.add(HeaderInterceptors());
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(LogsInterceptors());
    // _dio.interceptors.add(ResponseInterceptors());
  }

  requestHttp(url, params, Map<String, dynamic> header, Options option) async {
    print("-------------request");
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());

    ///no network
    if (connectivityResult == ConnectivityResult.none) {
      throw HttpError(message: 'No internet connection! Please try again');
    }

    Response response;
    try {
      print(option.method + ' url...........' + url);
      response = await _dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      print('request error...........' + e.toString());
      print('request error...........${e.response}');
      HttpError httpError = HttpError();
      httpError.statusCode = e.response?.statusCode;

      if (e.response?.statusCode == 401 || e.response?.statusCode == 403 || e.response?.statusCode == 406) {
        httpError.action = HttpActionError.LOGIN;
      } 
      if (e.response != null && e.response.data != null) {
        httpError.message = e.response.data.toString();
      } 
      // else if (e.message != null) {
      //   httpError.message = e.message;
      // } 
      else {
        httpError.message = _handleError(e);
      }

      throw (httpError);
    }
    return response?.data;
  }

  get(url, params) async {
    return await requestHttp(url, params, null, null);
  }

  post(url, params) async {
    return await requestHttp(url, params, null, Options(method: "post"));
  }

  put(url, params) async {
    return await requestHttp(url, params, null, Options(method: "put"));
  }

  delete(url, params) async {
    return await requestHttp(url, params, null, Options(method: "delete"));
  }

  _handleError(DioError error) {
    String errorDescription = "";
    if (error is DioError) {

      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Unable to establish connection with the server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription = "Connection to server failed";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription = "Received invalid status code: ${error.response.statusCode}";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "SEND_TIMEOUT";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}

final HttpManager httpManager = HttpManager();

class HttpError {
  HttpError({this.statusCode, this.message, this.action});

  int statusCode;
  String message;
  HttpActionError action;
}

enum HttpActionError {
  LOGIN,
  DEFAULT,
}
