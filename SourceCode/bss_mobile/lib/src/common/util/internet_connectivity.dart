import 'dart:async';
import 'package:connectivity/connectivity.dart';

class InternetConnectivity {
  static var connectivityResult;
  static bool internet = true;
  static Connectivity connectivity;
  static StreamSubscription<ConnectivityResult> subscription;

  static Future checkConnectivity() async {
    connectivity = new Connectivity();
    connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none)
      internet = false;
    else
      internet = true;
  }
}
