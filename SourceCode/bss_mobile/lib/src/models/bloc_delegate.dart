import 'package:bss_mobile/src/common/http_client.dart';

abstract class BlocDelegate<T>{

    success(T t);
    error(HttpError errorMessage);
}